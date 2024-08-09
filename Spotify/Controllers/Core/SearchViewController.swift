//
//  SearchViewController.swift
//  Spotify
//
//  Created by Rami Elwan on 23.07.24.
//

import UIKit

class SearchViewController: UIViewController {
    
    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Songs, Artists, Albums"
        vc.searchBar.searchBarStyle = .default
        vc.definesPresentationContext = true
        
        return vc
    }()
    
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

        searchController.searchResultsUpdater = self
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
        setupCollectionView()
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func setupCollectionView(){
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = view.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell else {
            fatalError()
        }
        cell.configure(with: "Rock")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchResultsController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces),
              query.count > 0 else {
            return
        }
        
        print(query)
    }
    
    
}

