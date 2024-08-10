import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"


    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true

        return imageView
    }()

    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center

        return label
    }()

    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center

        return label
    }()

    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)

        return stack
    }()

    private let labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical

        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        labelsStack.addArrangedSubview(playlistNameLabel)
        labelsStack.addArrangedSubview(creatorNameLabel)

        mainStack.addArrangedSubview(playlistCoverImageView)
        mainStack.addArrangedSubview(labelsStack)

        contentView.addSubview(mainStack)

        setUpConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpConstraints() {
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                playlistCoverImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
                playlistCoverImageView.heightAnchor.constraint(equalTo: playlistCoverImageView.widthAnchor),

                mainStack.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
                mainStack.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
        )
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
