import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let IMAGE_SIZE: CGFloat = 64
    static let identifier = "RecommendedTrackCollectionViewCell"
    static let PADDING: CGFloat = 4

    private let trackCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: RecommendedTrackCollectionViewCell.IMAGE_SIZE),
            imageView.heightAnchor.constraint(equalToConstant: RecommendedTrackCollectionViewCell.IMAGE_SIZE)
        ])
        imageView.clipsToBounds = true

        return imageView
    }()

    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.numberOfLines = 0

        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)

        return label
    }()

    private let dummyView: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.dragThatCanResizeScene, for: .vertical)

        return view
    }()

    private let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.axis = .vertical
        stack.backgroundColor = .secondarySystemBackground

        return stack
    }()

    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8

        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(mainStack)

        mainStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: RecommendedTrackCollectionViewCell.PADDING),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -RecommendedTrackCollectionViewCell.PADDING),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -RecommendedTrackCollectionViewCell.PADDING)
        ])

        labelStack.addArrangedSubview(trackNameLabel)
        labelStack.addArrangedSubview(artistNameLabel)
        labelStack.addArrangedSubview(dummyView)

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

    func configure(with viewModel: RecommendedTrackCellViewModel) {
        print("Configuring \(viewModel.name)")
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        trackCoverImageView.sd_setImage(with: viewModel.artworkURL)
    }
}
