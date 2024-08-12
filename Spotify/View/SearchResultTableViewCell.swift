//
//  SearchResultTableViewCell.swift
//  Spotify
//
//  Created by Rami Elwan on 12.08.24.
//

import UIKit
import SDWebImage

class SearchResultTableViewCell: UITableViewCell {
    static let identifier = "SearchResultTableViewCell"
    static let IMAGE_SIZE: CGFloat = 48
    
    private let title = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        
        return label
    }()
    
    private let subtitle = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        
        return label
    }()
    
    private let imgView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let mainStack = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        return stackView
    }()
    
    private let labelsStack = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        
        let titleStackView = UIStackView()
        titleStackView.axis = .horizontal
        titleStackView.alignment = .top
        titleStackView.addArrangedSubview(title)
        labelsStack.addArrangedSubview(titleStackView)
        
        let subTitleStackView = UIStackView()
        subTitleStackView.axis = .horizontal
        subTitleStackView.alignment = .top
        subTitleStackView.addArrangedSubview(subtitle)
        labelsStack.addArrangedSubview(subTitleStackView)
        
        mainStack.addArrangedSubview(imgView)
        mainStack.addArrangedSubview(labelsStack)
        
        contentView.addSubview(mainStack)
        
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalToConstant: SearchResultTableViewCell.IMAGE_SIZE),
            imgView.heightAnchor.constraint(equalToConstant: SearchResultTableViewCell.IMAGE_SIZE),
            
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configureWith(viewModel: SearchResultTableViewCellViewModel){
        if(viewModel.artworkUrl != nil) {
            imgView.sd_setImage(with: viewModel.artworkUrl)
        } else {
            imgView.image = UIImage(systemName: "photo")
        }
        title.text = viewModel.title
        subtitle.text = viewModel.subtitle
        
        subtitle.isHidden = viewModel.subtitle == nil
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
