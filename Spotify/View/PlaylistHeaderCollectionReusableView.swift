//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Rami Elwan on 07.08.24.
//

import UIKit
import SDWebImage

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        
        DispatchQueue.main.async {
            self.setupConstraints()
        }
    }
    
    private func setupConstraints() {
        let imageSize = height / 1.8
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        ownerLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            ownerLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            ownerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            ownerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(with viewModel: PlaylistHeaderViewModel) {
        nameLabel.text = "A very very long long name that probs span two lines"
        ownerLabel.text = viewModel.ownerName
        imageView.sd_setImage(with: viewModel.artworkUrl)
    }
}
