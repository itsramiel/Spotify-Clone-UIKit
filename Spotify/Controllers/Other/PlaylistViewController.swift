import UIKit

class PlaylistViewController: UIViewController {
    private let playlist: Playlist
    private var tracks = [Track]()

    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            let section = CollectionSectionBuilder.getTracksSection()
            
            section.boundarySupplementaryItems = [
                CollectionSectionBuilder.getCoverHeaderSupplementaryItem()
            ]

            return section
        })
    )

    init(playlist: Playlist) {
        self.playlist = playlist
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
        PlaybackPresenter.startPlayback(from: self, tracks: tracks)
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
        cell.configure(with: CoverHeaderViewModel(title: playlist.name, subtitle1: playlist.owner.displayName, subtitle2: playlist.description, artworkUrl: URL(string: playlist.images.first?.url ?? "")))
        
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
        PlaybackPresenter.startPlayback(from: self, tracks: [track])
    }
}

