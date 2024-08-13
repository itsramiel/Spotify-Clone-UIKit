//
//  SearchViewController.swift
//  Spotify
//
//  Created by Rami Elwan on 23.07.24.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController {
    var searchDebounceTimer: Timer?
    
    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Songs, Artists, Albums"
        vc.searchBar.searchBarStyle = .default
        vc.definesPresentationContext = true
        
        return vc
    }()
    
    var searchResultsViewController: SearchResultsViewController? {
        guard let controller = searchController.searchResultsController as? SearchResultsViewController else {
            return nil
        }
        
        return controller
    }
    
    private var categories = [Category]()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ in
                
                let countPerRow = 2
                
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1/CGFloat(countPerRow)),
                        heightDimension: .uniformAcrossSiblings(estimate: 60)
                    )
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(60)
                    ),
                    subitems: Array(repeating: item, count: countPerRow)
                )
                
                group.interItemSpacing = .fixed(12)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 24
                
                return section
            }
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultsViewController?.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
        setupCollectionView()
        
        APIManager.shared.getCategories { [weak self] result in
            guard case let .success(response) = result else {
                return
            }
            
            self?.categories = response.categories.items
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func setupCollectionView(){
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = view.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            fatalError()
        }
        
        let category = categories[indexPath.row]
        cell.configure(with: CategoryCollectionViewCellViewModel(name: category.name, artowrkUrl: URL(string: category.icons.first?.url ?? "")))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CategoryViewController(category: categories[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension SearchViewController:UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces),
              query.count > 0 else {
            return
        }
        
        searchDebounceTimer?.invalidate()
        
        searchDebounceTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(performSearch),
            userInfo: query,
            repeats: false
        )
    }
    
    @objc private func performSearch() {
        guard let query = searchDebounceTimer?.userInfo as? String else { return }
        APIManager.shared.search(
            with: query) { [weak self] result in
                guard case let .success(response) = result else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.searchResultsViewController?.update(with: [
                        SearchSection(title: "Songs", data: response.tracks.items.map({ .track(model: $0 )})),
                        SearchSection(title: "Artists", data: response.artists.items.map({ .artist(model: $0 )})),
                        SearchSection(title: "Albums", data: response.albums.items.map({ .album(model: $0 )})),
                        SearchSection(title: "Playlists", data: response.playlists.items.map({ .playlist(model: $0 )}))
                    ])
                }
            }
    }
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    func didTapSearchResult(_ searchResult: SearchResult) {
        switch searchResult {
        case .artist(model: let model):
            if let url = URL(string: model.externalUrls["spotify"] ?? "") {
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true)
            }
        case .album(model: let model):
            let vc = AlbumViewController(album: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .track(model: let track):
            PlaybackPresenter.startPlayback(from: self, tracks: [track])
        case .playlist(model: let model):
            let vc = PlaylistViewController(playlist: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
