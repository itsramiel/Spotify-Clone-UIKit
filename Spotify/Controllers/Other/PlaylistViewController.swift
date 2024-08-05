import UIKit

class PlaylistViewController: UIViewController {
    private let playlist: Playlist

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
    }
}
