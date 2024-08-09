//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by Rami Elwan on 09.08.24.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    private static let IMAGE_SIZE: CGFloat = 60
    
    private let colors: [UIColor] = [
        .systemRed,
        .systemGreen,
        .systemBlue,
        .systemPink,
        .systemPurple,
        .systemOrange,
        .systemTeal,
        .systemMint,
        .systemCyan,
        .systemBrown,
        .systemIndigo,
    ]
    
    private let imageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        imageView.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)
        )
        
        return imageView
    }()
    
    private let label = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupConstraints() {
        let mainStack = UIStackView()
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        mainStack.axis = .vertical
        
        let topStackView = UIStackView()
        topStackView.addArrangedSubview(imageView)
        topStackView.axis = .vertical
        topStackView.alignment = .trailing
        
        let bottomStackView = UIStackView()
        bottomStackView.addArrangedSubview(label)
        bottomStackView.axis = .vertical
        bottomStackView.alignment = .leading

        mainStack.addArrangedSubview(topStackView)
        mainStack.addArrangedSubview(bottomStackView)
        mainStack.distribution = .fill
        mainStack.spacing = 8
        
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: CategoryCollectionViewCell.IMAGE_SIZE),
            imageView.heightAnchor.constraint(equalToConstant: CategoryCollectionViewCell.IMAGE_SIZE),

            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configure(with viewModel: CategoryCollectionViewCellViewModel){
        label.text = viewModel.name
        imageView.sd_setImage(with: viewModel.artowrkUrl)
        contentView.backgroundColor = colors.randomElement()
    }
}
