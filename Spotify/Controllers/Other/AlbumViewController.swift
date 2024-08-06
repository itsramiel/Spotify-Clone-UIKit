import UIKit

class AlbumViewController: UIViewController {
    private let album: Album

    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground

        APIManager.shared.getAlbumDetailWith(albumId: album.id, completion: { result in
            guard case let .success(album) = result else { return }
            print(album)
        })
    }
}
