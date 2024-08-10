//
//  CategoryViewController.swift
//  Spotify
//
//  Created by Rami Elwan on 10.08.24.
//

import UIKit

class CategoryViewController: UIViewController {
    let category: Category
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ in
                let itemsPerGroup = 2
                
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1 / CGFloat(itemsPerGroup)),
                        heightDimension: .uniformAcrossSiblings(estimate: 60)
                    )
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(60)
                    ),
                    subitems: Array(repeating: item, count: 2)
                )
                
                group.interItemSpacing = .fixed(12)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 12
                
                return section
            }
        )
        
    )
    
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private var playlists = [Playlist]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = category.name
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        setupCollectionView()
        
        APIManager.shared.getPlaylistsForCategory(with: category.id) { [weak self] result in
            guard let response = try? result.get() else {
                return
            }
            
            self?.playlists = response.playlists.items
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            FeaturedPlaylistCollectionViewCell.self,
            forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
            fatalError()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(
            with: FeaturedPlaylistCellViewModel(
                name: playlist.name,
                artworkURL: URL(string: playlist.images.first?.url ?? ""),
                creatorName: playlist.owner.displayName
            )
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        let vc = PlaylistViewController(playlist: playlist)
        navigationController?.pushViewController(vc, animated: true)
    }
}
