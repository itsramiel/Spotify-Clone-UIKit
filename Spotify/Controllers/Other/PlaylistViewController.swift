import UIKit

class PlaylistViewController: UIViewController {
    private let playlist: Playlist
    private var trackViewModels = [RecommendedTrackCellViewModel]()

    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            let size = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1), heightDimension: .estimated(64)
            )

            let item = NSCollectionLayoutItem(layoutSize: size)

            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: size,
                subitems: Array(repeating: item, count: 1)
            )

            return NSCollectionLayoutSection(group: group)
        })
    )

    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
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
            self.trackViewModels = playlist.tracks.items.map {
                RecommendedTrackCellViewModel(
                    name: $0.track.name,
                    artworkURL: URL(string: $0.track.album.images.first?.url ?? ""),
                    artistName: $0.track.artists.first?.name ?? ""
                )
            }

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
            RecommendedTrackCollectionViewCell.self,
            forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier
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

extension PlaylistViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return trackViewModels.count
   }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
            fatalError("Invalid cell type")
        }

        cell.configure(with: trackViewModels[indexPath.row])

        return cell
    }
}
