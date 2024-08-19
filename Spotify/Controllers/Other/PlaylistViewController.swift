import UIKit

class PlaylistViewController: UIViewController {
    private let playlist: Playlist
    private let isOwner: Bool
    private var tracks = [Track]()

    lazy private var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
                
                // Create the layout for the header
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(300)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                
                // Create a list configuration with no sticky header
                var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
                
                configuration.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
                    guard let self else { fatalError() }
                    let track = self.tracks[indexPath.row]
                    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
                        APIManager.shared.RemoveTrackWith(uri: track.uri, fromPlaylistWith: self.playlist.id, completion: { success in
                            DispatchQueue.main.async {
                                self.tracks.remove(at: indexPath.row)
                                self.collectionView.deleteItems(at: [indexPath])
                                completion(success)
                            }
                        })
                    }
                    return UISwipeActionsConfiguration(actions: [deleteAction])
                }
                
                
                // Create the section with the header item
                let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
                section.interGroupSpacing = 8
                section.boundarySupplementaryItems = [header]
                
                return section
            }
        )
        
        return view
    }()

    init(playlist: Playlist, isOwner: Bool = false) {
        self.playlist = playlist
        self.isOwner = isOwner
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
    }
    
    @objc private func didTapShare() {
        guard let url = playlist.externalUrls["spotify"] else { return }
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        
        present(vc, animated: true)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        navigationItem.largeTitleDisplayMode = .never

        view.backgroundColor = .systemBackground

        APIManager.shared.getPlaylistDetailWith(playlistId: playlist.id, completion: { result in
            guard case let .success(playlist) = result else { return }
            self.tracks = playlist.tracks.items.map({$0.track})

            DispatchQueue.main.async {
                self.setupCollectionView()
            }
        })
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(
            PlaylistTrackCollectionViewCell.self,
            forCellWithReuseIdentifier: PlaylistTrackCollectionViewCell.identifier
        )
        collectionView.register(
            CoverHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CoverHeaderCollectionReusableView.identifier
        )

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        collectionView.reloadData()
    }
}

extension PlaylistViewController: CoverHeaderCollectionReusableViewDelegate {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: CoverHeaderCollectionReusableView) {
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
}

extension PlaylistViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let cell = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CoverHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? CoverHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        
        cell.delegate = self
        cell.configure(with: CoverHeaderViewModel(title: playlist.name, subtitle1: playlist.owner.displayName ?? playlist.owner.id, subtitle2: playlist.description ?? "", artworkUrl: URL(string: playlist.images?.first?.url ?? "")))
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistTrackCollectionViewCell.identifier, for: indexPath) as? PlaylistTrackCollectionViewCell else {
            fatalError("Invalid cell type")
        }

        let track = tracks[indexPath.row]
        cell.configure(with:
                        PlaylistTrackCellViewModel(
                            name: track.name,
                            artworkURL: URL(string: track.album?.images.first?.url ?? ""),
                            artistName: track.artists.first?.name ?? ""
                        )
        )

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let track = tracks[indexPath.row]
        PlaybackPresenter.shared.startPlayback(from: self, tracks: [track])
    }
}

