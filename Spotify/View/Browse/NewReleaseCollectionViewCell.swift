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

        return label
    }()

    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)

        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.addSubview(artistNameLabel)

        contentView.clipsToBounds = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        albumCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        albumCoverImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: NewReleaseCollectionViewCell.PADDING).isActive = true
        albumCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: NewReleaseCollectionViewCell.PADDING).isActive = true
        albumCoverImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height - NewReleaseCollectionViewCell.PADDING * 2).isActive = true
        albumCoverImageView.widthAnchor.constraint(equalTo: albumCoverImageView.heightAnchor).isActive = true

        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
        albumNameLabel.leftAnchor.constraint(equalTo: albumCoverImageView.rightAnchor, constant: NewReleaseCollectionViewCell.PADDING).isActive = true
        albumNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: NewReleaseCollectionViewCell.PADDING).isActive = true
        albumNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -NewReleaseCollectionViewCell.PADDING).isActive = true

        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.leftAnchor.constraint(equalTo: albumCoverImageView.rightAnchor, constant: NewReleaseCollectionViewCell.PADDING).isActive = true
        artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: NewReleaseCollectionViewCell.PADDING).isActive = true
        artistNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -NewReleaseCollectionViewCell.PADDING).isActive = true

        numberOfTracksLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfTracksLabel.leftAnchor.constraint(equalTo: albumCoverImageView.rightAnchor, constant: NewReleaseCollectionViewCell.PADDING).isActive = true
        numberOfTracksLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -NewReleaseCollectionViewCell.PADDING).isActive = true
        numberOfTracksLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -NewReleaseCollectionViewCell.PADDING).isActive = true
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
