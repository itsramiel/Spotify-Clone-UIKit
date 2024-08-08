//
//  HomeHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Rami Elwan on 08.08.24.
//

import UIKit

class HomeHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "HomeHeaderCollectionReusableView"
    static let PADDING: CGFloat = 4
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(label)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: HomeHeaderCollectionReusableView.PADDING),
            label.topAnchor.constraint(equalTo: topAnchor, constant: HomeHeaderCollectionReusableView.PADDING),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -HomeHeaderCollectionReusableView.PADDING),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -HomeHeaderCollectionReusableView.PADDING),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with title: String) {
        label.text = title
    }
}
