import UIKit

class PlaylistTrackCollectionViewCell: UICollectionViewCell {
    static let IMAGE_SIZE: CGFloat = 48
    static let identifier = "PlaylistTrackCollectionViewCell"
    static let PADDING: CGFloat = 4

    private let trackCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0

        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .light)

        return label
    }()

    private let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        stack.axis = .vertical

        return stack
    }()

    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.backgroundColor = .secondarySystemBackground
        stack.alignment = .center
        stack.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        stack.isLayoutMarginsRelativeArrangement = true

        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(mainStack)

        mainStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            trackCoverImageView.widthAnchor.constraint(equalToConstant: PlaylistTrackCollectionViewCell.IMAGE_SIZE),
            trackCoverImageView.heightAnchor.constraint(equalToConstant: PlaylistTrackCollectionViewCell.IMAGE_SIZE),
            
            mainStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: PlaylistTrackCollectionViewCell.PADDING),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: PlaylistTrackCollectionViewCell.PADDING),
            mainStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -PlaylistTrackCollectionViewCell.PADDING),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -PlaylistTrackCollectionViewCell.PADDING)
        ])

        labelStack.addArrangedSubview(trackNameLabel)
        labelStack.addArrangedSubview(artistNameLabel)

        mainStack.addArrangedSubview(trackCoverImageView)
        mainStack.addArrangedSubview(labelStack)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        trackCoverImageView.image = nil
    }

    func configure(with viewModel: PlaylistTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        if let artworkUrl = viewModel.artworkURL {
            trackCoverImageView.sd_setImage(with: artworkUrl)
        } else {
            trackCoverImageView.isHidden = true
        }
    }
}
