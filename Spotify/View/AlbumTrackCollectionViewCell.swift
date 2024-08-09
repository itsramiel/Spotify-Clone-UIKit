import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumTrackCollectionViewCell"
    static let H_PADDING: CGFloat = 16
    static let V_PADDING: CGFloat = 8
    static let GAP :CGFloat = 4

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

    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        stack.backgroundColor = .secondarySystemBackground
        stack.layoutMargins = UIEdgeInsets(
            top: AlbumTrackCollectionViewCell.V_PADDING,
            left: AlbumTrackCollectionViewCell.H_PADDING,
            bottom: AlbumTrackCollectionViewCell.V_PADDING,
            right: AlbumTrackCollectionViewCell.H_PADDING
        )
        stack.isLayoutMarginsRelativeArrangement = true

        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AlbumTrackCollectionViewCell.GAP)
        ])

        mainStack.addArrangedSubview(trackNameLabel)
        mainStack.addArrangedSubview(artistNameLabel)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }

    func configure(with viewModel: AlbumTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
}

