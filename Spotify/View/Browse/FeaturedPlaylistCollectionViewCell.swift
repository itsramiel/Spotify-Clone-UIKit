import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"

    private static let PADDING: CGFloat = 4
    private static let MAIN_STACK_GAP: CGFloat = 4
    private static let LABELS_STACK_GAP: CGFloat = 4
    private static let PLAYLIST_COVER_IMAGE_SIZE: CGFloat = 160
    private static let PLAYLIST_NAME_NUMBER_OF_LINES = 2
    private static let PLAYLIST_NAME_FONT_SIZE: CGFloat = 18
    private static let CREATOR_NAME_NUMBER_OF_LINES = 1
    private static let CREATOR_NAME_FONT_SIZE: CGFloat = 14

    static let WIDTH: CGFloat =
        PLAYLIST_COVER_IMAGE_SIZE + PADDING * 2

    static let PLAYLIST_NAME_HEIGHT: CGFloat =
        UIFont.systemFont(ofSize: PLAYLIST_NAME_FONT_SIZE).lineHeight * CGFloat(PLAYLIST_NAME_NUMBER_OF_LINES)

    static let CREATOR_NAME_HEIGHT: CGFloat =
        UIFont.systemFont(ofSize: CREATOR_NAME_FONT_SIZE).lineHeight * CGFloat(CREATOR_NAME_NUMBER_OF_LINES)

    static let ESTIMATED_HEIGHT: CGFloat =
        PLAYLIST_COVER_IMAGE_SIZE +
        PLAYLIST_NAME_HEIGHT + CREATOR_NAME_HEIGHT
        + MAIN_STACK_GAP
        + LABELS_STACK_GAP
        + PADDING * 2

    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: PLAYLIST_COVER_IMAGE_SIZE),
            imageView.heightAnchor.constraint(equalToConstant: PLAYLIST_COVER_IMAGE_SIZE)
        ])

        return imageView
    }()

    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = PLAYLIST_NAME_NUMBER_OF_LINES
        label.font = .systemFont(ofSize: PLAYLIST_NAME_FONT_SIZE, weight: .semibold)

        return label
    }()

    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = CREATOR_NAME_NUMBER_OF_LINES
        label.font = .systemFont(ofSize: CREATOR_NAME_FONT_SIZE, weight: .regular)

        return label
    }()

    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = MAIN_STACK_GAP
        stack.alignment = .fill

        return stack
    }()

    private let labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = LABELS_STACK_GAP
        stack.distribution = .equalSpacing

        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        labelsStack.addArrangedSubview(playlistNameLabel)
        labelsStack.addArrangedSubview(creatorNameLabel)

        mainStack.addArrangedSubview(playlistCoverImageView)
        mainStack.addArrangedSubview(labelsStack)

        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(mainStack)

        setUpConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpConstraints() {
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: FeaturedPlaylistCollectionViewCell.PADDING),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: FeaturedPlaylistCollectionViewCell.PADDING),
            mainStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -FeaturedPlaylistCollectionViewCell.PADDING),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -FeaturedPlaylistCollectionViewCell.PADDING)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistCoverImageView.image = nil
    }

    func configure(with viewModel: FeaturedPlaylistCellViewModel) {
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL)
    }
}
