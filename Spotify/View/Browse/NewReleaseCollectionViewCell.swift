import SDWebImage
import UIKit

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"

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
        albumNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        artistNameLabel.sizeToFit()

        print(contentView.frame)

        let imageSize: CGFloat = contentView.height - 10
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)

        let albumLabelSize = albumNameLabel.sizeThatFits(
            CGSize(width: contentView.width - imageSize - 10, height: contentView.height - 10)
        )

        albumNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: 5,
            width: albumLabelSize.width,
            height: albumLabelSize.height
        )

        numberOfTracksLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: albumCoverImageView.bottom - 50,
            width: numberOfTracksLabel.width,
            height: 50
        )
        print(numberOfTracksLabel.frame)
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
