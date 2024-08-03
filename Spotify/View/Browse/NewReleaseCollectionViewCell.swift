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
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        return label
    }()

    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .fill

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(stackView)

        stackView.addArrangedSubview(albumNameLabel)
        stackView.addArrangedSubview(numberOfTracksLabel)
        stackView.addArrangedSubview(artistNameLabel)

        contentView.clipsToBounds = true
        setUpConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpConstraints() {
        albumCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            albumCoverImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: NewReleaseCollectionViewCell.PADDING),
            albumCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: NewReleaseCollectionViewCell.PADDING),
            albumCoverImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height - NewReleaseCollectionViewCell.PADDING * 2),
            albumCoverImageView.widthAnchor.constraint(equalTo: albumCoverImageView.heightAnchor),

            stackView.leftAnchor.constraint(equalTo: albumCoverImageView.rightAnchor, constant: NewReleaseCollectionViewCell.PADDING),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: NewReleaseCollectionViewCell.PADDING),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -NewReleaseCollectionViewCell.PADDING),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -NewReleaseCollectionViewCell.PADDING)
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
