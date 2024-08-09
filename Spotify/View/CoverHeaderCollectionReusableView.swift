//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Rami Elwan on 07.08.24.
//

import UIKit
import SDWebImage

protocol CoverHeaderCollectionReusableViewDelegate: AnyObject {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: CoverHeaderCollectionReusableView)
}

final class CoverHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "CoverHeaderCollectionReusableView"
    
    weak var delegate: CoverHeaderCollectionReusableViewDelegate?
    
    private static let PLAY_BUTTON_SIZE: CGFloat = 60
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let subtitle1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        
        return label
    }()
    
    private let subtitle2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .light)
        
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

            playButton.widthAnchor.constraint(equalToConstant: CoverHeaderCollectionReusableView.PLAY_BUTTON_SIZE),
            playButton.heightAnchor.constraint(equalToConstant: CoverHeaderCollectionReusableView.PLAY_BUTTON_SIZE)
        ])
        

        let stackView = UIStackView()
        row.addArrangedSubview(stackView)
        row.addArrangedSubview(playButton)
        stackView.spacing = 12
        stackView.axis = .vertical
        
        if let text = titleLabel.text, text.count > 0 {
            stackView.addArrangedSubview(titleLabel)
        }
        if let text = subtitle1.text, text.count > 0 {
            stackView.addArrangedSubview(subtitle1)
        }
        if let text = subtitle2.text, text.count > 0 {
            stackView.addArrangedSubview(subtitle2)
        }
        

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(with viewModel: CoverHeaderViewModel) {
        titleLabel.text = viewModel.title
        subtitle1.text = viewModel.subtitle1
        subtitle2.text = viewModel.subtitle2
        imageView.sd_setImage(with: viewModel.artworkUrl)
        
        self.setupConstraints()
    }
}
