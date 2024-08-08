//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Rami Elwan on 07.08.24.
//

import UIKit
import SDWebImage

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private static let PLAY_BUTTON_SIZE: CGFloat = 60
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .light)
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        
        return imageView
    }()
    
    private let playButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 0.6 * PLAY_BUTTON_SIZE))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = PLAY_BUTTON_SIZE/2
        button.layer.masksToBounds = true
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        playButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    @objc private func didTapPlayAll() {
        delegate?.playlistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    private func setupConstraints() {
        let imageSize = height / 1.8
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),
        ])
        
        let row = UIStackView()
        row.axis = .horizontal
        addSubview(row)
        row.spacing = 12
        row.alignment = .top
        row.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            row.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            row.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            row.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            playButton.widthAnchor.constraint(equalToConstant: PlaylistHeaderCollectionReusableView.PLAY_BUTTON_SIZE),
            playButton.heightAnchor.constraint(equalToConstant: PlaylistHeaderCollectionReusableView.PLAY_BUTTON_SIZE)
        ])
        

        let stackView = UIStackView()
        row.addArrangedSubview(stackView)
        row.addArrangedSubview(playButton)
        stackView.spacing = 12
        stackView.axis = .vertical
        
        if let text = nameLabel.text, text.count > 0 {
            stackView.addArrangedSubview(nameLabel)
        }
        if let text = descriptionLabel.text, text.count > 0 {
            stackView.addArrangedSubview(descriptionLabel)
        }
        if let text = ownerLabel.text, text.count > 0 {
            stackView.addArrangedSubview(ownerLabel)
        }
        

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(with viewModel: PlaylistHeaderViewModel) {
        nameLabel.text = viewModel.name
        ownerLabel.text = viewModel.ownerName
        imageView.sd_setImage(with: viewModel.artworkUrl)
        
        self.setupConstraints()
    }
}
