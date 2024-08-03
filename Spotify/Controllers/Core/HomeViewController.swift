//
//  HomeViewController.swift
//  Spotify
//
//  Created by Rami Elwan on 23.07.24.
//

import UIKit

enum BrowseSectionType {
    case newReleases(viewModels: [NewReleasesCellViewModel])
    case featuredPlaylists(viewModels: [NewReleasesCellViewModel])
    case recommendedTracks(viewModels: [NewReleasesCellViewModel])
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
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }

    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
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
        APIManager.shared.getRecommendations(completion: { result in
            defer { group.leave() }

            guard case let .success(response) = result else { return }
            recommendations = response
        })

        group.notify(queue: .main) {
            guard let newReleases, let featuredPlaylists, let recommendations else { return }

            self.configureModels(
                newAlbmus: newReleases.albums.items,
                playlists: featuredPlaylists.playlists.items,
                tracks: recommendations.tracks
            )
        }
    }

    private func configureModels(newAlbmus: [Album], playlists _: [Playlist], tracks _: [Track]) {
        sections.append(
            .newReleases(viewModels: newAlbmus.compactMap { NewReleasesCellViewModel(
                name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), numberOfTracks: $0.totalTracks, artistName: $0.artists.first?.name ?? ""
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
        switch section {
        case 0:
            let item = NSCollectionLayoutItem(layoutSize:
                NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1 / 3)
                )
            )

            item.contentInsets = .init(top: 0, leading: 0, bottom: 4, trailing: 4)

            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ),
                subitems: Array(repeating: item, count: 3)
            )

            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(360)
                ),
                subitems: [verticalGroup]
            )

            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        case 1:
            let item = NSCollectionLayoutItem(layoutSize:
                NSCollectionLayoutSize(
                    widthDimension: .fractionalHeight(0.5),
                    heightDimension: .fractionalHeight(0.5)
                )
            )

            item.contentInsets = .init(top: 0, leading: 0, bottom: 4, trailing: 4)

            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(400)
                ),
                subitems: Array(repeating: item, count: 2)
            )

            let section = NSCollectionLayoutSection(group: verticalGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section
        case 2:
            fallthrough
        default:
            let item = NSCollectionLayoutItem(layoutSize:
                NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )

            item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)

            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(80)
                ),
                subitems: Array(repeating: item, count: 1)
            )

            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case let .newReleases(viewModels: viewModels):
            fallthrough
        case let .featuredPlaylists(viewModels: viewModels):
            fallthrough
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
            let viewModel = viewModels[indexPath.row]

            cell.configure(with: viewModel)
            return cell
        case let .featuredPlaylists(viewModels: viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath
            ) as? FeaturedPlaylistCollectionViewCell else { fatalError("Invalid cell type") }
            cell.backgroundColor = .systemBlue
            return cell
        case let .recommendedTracks(viewModels: viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath
            ) as? RecommendedTrackCollectionViewCell else { fatalError("Invalid cell type") }
            cell.backgroundColor = .systemRed
            return cell
        }
    }
}
