//
//  HomeViewController.swift
//  Spotify
//
//  Created by Rami Elwan on 23.07.24.
//

import UIKit

enum BrowseSectionType {
    case newReleases(viewModels: [NewReleasesCellViewModel])
    case featuredPlaylists(viewModels: [FeaturedPlaylistCellViewModel])
    case recommendedTracks(viewModels: [PlaylistTrackCellViewModel])
    
    var title: String {
        switch self {
        case .newReleases: return "New Releases"
        case .featuredPlaylists: return "Featured Playlists"
        case .recommendedTracks: return "Recommended Tracks"
        }
    }
}

class HomeViewController: UIViewController {
    private var sections = [BrowseSectionType]()
    
    private var collectionView: UICollectionView = .init(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            createSectionLayout(section: sectionIndex)
        })
    )
    
    private let spinner = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapGear)
        )
        
        congigureCollectionView()
        view.addSubview(spinner)
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func congigureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(PlaylistTrackCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistTrackCollectionViewCell.identifier)
        collectionView.register(HomeHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeaderCollectionReusableView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    private var albums = [Album]()
    private var playlists = [Playlist]()
    private var tracks = [Track]()
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponse?
        var featuredPlaylists: FeaturedPlaylistsResponse?
        var recommendations: GetRrecommendationsResponse?
        
        // New Releases
        APIManager.shared.getNewReleases(completion: { result in
            defer { group.leave() }
            
            guard case let .success(response) = result else { return }
            newReleases = response
        })
        
        // Featured Playlists
        APIManager.shared.getFeaturedPlaylists(completion: { result in
            defer { group.leave() }
            
            guard case let .success(response) = result else { return }
            featuredPlaylists = response
        })
        // Recommended Tracks
//        APIManager.shared.getRecommendations(completion: { result in
//            defer { group.leave() }
//            
//            guard case let .success(response) = result else { return }
//            recommendations = response
//        })
        
        group.notify(queue: .main) {
            guard let newReleases, let featuredPlaylists/*, let recommendations*/ else { return }
            
            self.albums = newReleases.albums.items
            self.playlists = featuredPlaylists.playlists.items
//            self.tracks = recommendations.tracks
            self.configureModels(
            )
        }
    }
    
    private func configureModels() {
        sections.append(
            .newReleases(viewModels: albums.map { NewReleasesCellViewModel(
                name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), numberOfTracks: $0.totalTracks, artistName: $0.artists.first?.name ?? ""
            ) })
        )
        
        sections.append(
            .featuredPlaylists(viewModels: playlists.map { FeaturedPlaylistCellViewModel(
                name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), creatorName: $0.owner.displayName
            ) })
        )
        
        sections.append(
            .recommendedTracks(viewModels: tracks.map { PlaylistTrackCellViewModel(
                name: $0.name, artworkURL: URL(string: $0.album.images.first?.url ?? ""), artistName: $0.artists.first?.name ?? ""
            ) })
        )
        
        collectionView.reloadData()
    }
    
    @objc func didTapGear() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1), heightDimension: .estimated(30)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        switch section {
        case 0:
            let item = NSCollectionLayoutItem(layoutSize:
                                                NSCollectionLayoutSize(
                                                    widthDimension: .fractionalWidth(1),
                                                    heightDimension: .fractionalHeight(1 / 3)
                                                )
            )
            
            item.contentInsets = .init(top: 0, leading: 0, bottom: 4, trailing: 4)
            
            let itemsCount = 3
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ),
                subitems: Array(repeating: item, count: itemsCount)
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(NewReleaseCollectionViewCell.HEIGHT * CGFloat(itemsCount))
                ),
                subitems: [verticalGroup]
            )
            
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 1:
            let item = NSCollectionLayoutItem(layoutSize:
                                                NSCollectionLayoutSize(
                                                    widthDimension: .fractionalWidth(1),
                                                    heightDimension: .uniformAcrossSiblings(estimate: 60)
                                                )
            )
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.4),
                    heightDimension: .uniformAcrossSiblings(estimate: 120)
                ),
                subitems: Array(repeating: item, count: 2)
            )
            verticalGroup.interItemSpacing = .fixed(12)
            
            let section = NSCollectionLayoutSection(group: verticalGroup)
            section.interGroupSpacing = 12
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        default:
            let size = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(64)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: size)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: size,
                subitems: Array(repeating: item, count: 1)
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case let .newReleases(viewModels: viewModels):
            return viewModels.count
        case let .featuredPlaylists(viewModels: viewModels):
            return viewModels.count
        case let .recommendedTracks(viewModels: viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in _: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        switch section {
        case let .newReleases(viewModels: viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath
            ) as? NewReleaseCollectionViewCell else { fatalError("Invalid cell type") }
            
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case let .featuredPlaylists(viewModels: viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath
            ) as? FeaturedPlaylistCollectionViewCell else { fatalError("Invalid cell type") }
            
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case let .recommendedTracks(viewModels: viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PlaylistTrackCollectionViewCell.identifier, for: indexPath
            ) as? PlaylistTrackCollectionViewCell else { fatalError("Invalid cell type") }
            
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let cell = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? HomeHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        
        cell.configure(with: sections[indexPath.section].title)
        
        return cell
    }
    
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case .newReleases:
            let album = albums[indexPath.row]
            let vc = AlbumViewController(album: album)
            navigationController?.pushViewController(vc, animated: true)
        case .featuredPlaylists:
            let playlist = playlists[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            navigationController?.pushViewController(vc, animated: true)
        case .recommendedTracks:
            break
        }
    }
}
