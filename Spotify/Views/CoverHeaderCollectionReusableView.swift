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
    
    private let mainstack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .fill
        view.axis = .vertical
        view.spacing = 16
        
        return view
    }()
    
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
    
    private let row: UIStackView = {
        let row = UIStackView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.spacing = 12
        row.alignment = .top
        
        return row
    }()
    
    private let labelsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.axis = .vertical
        
        return stackView
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
        addSubview(mainstack)
        self.setupConstraints()
    }
    
    @objc private func didTapPlayAll() {
        delegate?.playlistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    private func setupConstraints() {
        mainstack.addArrangedSubview(imageView)
        mainstack.addArrangedSubview(row)
        
        row.addArrangedSubview(labelsStack)
        row.addArrangedSubview(playButton)
        
        labelsStack.addArrangedSubview(titleLabel)
        labelsStack.addArrangedSubview(subtitle1)
        labelsStack.addArrangedSubview(subtitle2)

        NSLayoutConstraint.activate([
            mainstack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            mainstack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            mainstack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            mainstack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            
            imageView.widthAnchor.constraint(equalTo: mainstack.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            playButton.widthAnchor.constraint(equalToConstant: CoverHeaderCollectionReusableView.PLAY_BUTTON_SIZE),
            playButton.heightAnchor.constraint(equalToConstant: CoverHeaderCollectionReusableView.PLAY_BUTTON_SIZE),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with viewModel: CoverHeaderViewModel) {
        titleLabel.text = viewModel.title
        titleLabel.isHidden = viewModel.title.count == 0
        subtitle1.text = viewModel.subtitle1
        subtitle1.isHidden = viewModel.subtitle1.count == 0
        subtitle2.text = viewModel.subtitle2
        subtitle2.isHidden = viewModel.subtitle2.count == 0
        imageView.sd_setImage(with: viewModel.artworkUrl)
        imageView.isHidden = viewModel.artworkUrl == nil
    }
}
