import SDWebImage
import UIKit

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"
    static let HEIGHT: CGFloat = 130
    private static let PADDING: CGFloat = 5

    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)

        return label
    }()

    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .light)

        return label
    }()

    private let footerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.distribution = .fill
        stack.setContentHuggingPriority(.defaultHigh, for: .vertical)

        return stack
    }()

    private let trailingView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trailingView)

        footerStack.addArrangedSubview(numberOfTracksLabel)
        footerStack.addArrangedSubview(artistNameLabel)

        trailingView.addArrangedSubview(albumNameLabel)
        trailingView.addArrangedSubview(footerStack)

        contentView.clipsToBounds = true
        setUpConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpConstraints() {
        albumCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        trailingView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            albumCoverImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: NewReleaseCollectionViewCell.PADDING),
            albumCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: NewReleaseCollectionViewCell.PADDING),
            albumCoverImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height - NewReleaseCollectionViewCell.PADDING * 2),
            albumCoverImageView.widthAnchor.constraint(equalTo: albumCoverImageView.heightAnchor),

            trailingView.leftAnchor.constraint(equalTo: albumCoverImageView.rightAnchor, constant: NewReleaseCollectionViewCell.PADDING),
            trailingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: NewReleaseCollectionViewCell.PADDING),
            trailingView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -NewReleaseCollectionViewCell.PADDING),
            trailingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -NewReleaseCollectionViewCell.PADDING)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        numberOfTracksLabel.text = nil
        artistNameLabel.text = nil
        albumCoverImageView.image = nil
    }

    func configure(with viewModel: NewReleasesCellViewModel) {
        albumNameLabel.text = viewModel.name
        numberOfTracksLabel.text = "\(viewModel.numberOfTracks) Tracks"
        artistNameLabel.text = viewModel.artistName
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL)
    }
}
