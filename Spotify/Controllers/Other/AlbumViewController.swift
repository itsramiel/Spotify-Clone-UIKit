import UIKit

class AlbumViewController: UIViewController {
    var isSaved: Bool? = nil {
        didSet {
            setupHeaderRightButton()
            NotificationCenter.default.post(name: .albumSavedNotification, object: nil)
        }
    }
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let album: Album
    private var tracks = [Track]()
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
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
                
                
                // Create the section with the header item
                let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
                section.boundarySupplementaryItems = [header]
                
                return section
            }
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavigationBar()
        setupConstrainsts()
        view.backgroundColor = .systemBackground

        APIManager.shared.getAlbumDetailWith(albumId: album.id, completion: { [weak self] result in
            guard case let .success(albumDetail) = result, let album = self?.album else { return }
            var tracks = albumDetail.tracks.items
            let tracksWithAlbum = tracks.map({
                var track = $0
                track.album = album
                
                return track
            })
            self?.tracks = tracksWithAlbum
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        })
        
        APIManager.shared.getUserSavedAlbums {[weak self] result in
            guard case let .success(albums) = result, let self else {
                return
            }
            
            isSaved = albums.contains(where: {$0.id == self.album.id})
        }
        
    }
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        collectionView.register(AlbumTrackCollectionViewCell.self, forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier)
        collectionView.register(CoverHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CoverHeaderCollectionReusableView.identifier)
    }
    
    private func setupNavigationBar() {
        title = album.name
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupHeaderRightButton() {
        DispatchQueue.main.async { [weak self] in
            guard let self, let isSaved else { return }
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: isSaved  ? .trash : .save,
                target: self,
                action: isSaved ? #selector(removeAlbumFromSavedAlbums): #selector(addAlbumToSavedAlbums)
            )
        }
    }
    
    @objc private func removeAlbumFromSavedAlbums() {
        APIManager.shared.removeFromSavedAlbums(withId: album.id) { [weak self] success in
            HapticsManager.shared.feedback(type: success ? .success: .warning)
            if(success) {
                self?.isSaved = false
            }
        }
    }
    
    @objc private func addAlbumToSavedAlbums() {
        APIManager.shared.addToSavedAlbums(with: album.id) { [weak self] success in
            HapticsManager.shared.feedback(type: success ? .success: .warning)
            if(success) {
                self?.isSaved = true
            }
        }
    }
    
    private func setupConstrainsts() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension AlbumViewController: CoverHeaderCollectionReusableViewDelegate {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: CoverHeaderCollectionReusableView) {
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
}

extension AlbumViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumTrackCollectionViewCell.identifier,
            for: indexPath
        ) as? AlbumTrackCollectionViewCell else {
            fatalError("Cannot dequeue a track collection view cell")
        }
        let track = tracks[indexPath.row]
        cell.configure(with: AlbumTrackCellViewModel(name: track.name, artistName: track.artists.map({$0.name}).joined(separator: ", ")))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { fatalError("Supplementary view of kind: \(kind) is not implemented for AlbumViewController") }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CoverHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? CoverHeaderCollectionReusableView else {
            fatalError()
        }
        
        view.delegate = self
        
        view.configure(with: CoverHeaderViewModel(
            title: album.name,
            subtitle1: album.artists.first?.name ?? "",
            subtitle2: "Release Date: \(String.formattedDate(string: album.releaseDate))",
            artworkUrl: URL(string: album.images.first?.url ?? ""))
        )
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        PlaybackPresenter.shared.startPlayback(from: self, tracks: [tracks[indexPath.row]])
    }
    
}
