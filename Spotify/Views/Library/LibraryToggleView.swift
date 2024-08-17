//
//  LibraryToggleView.swift
//  Spotify
//
//  Created by Rami Elwan on 15.08.24.
//

import UIKit

protocol LibraryToggleViewDelegate: AnyObject {
    func libraryToggleViewDidTapPlaylistsButton()
    func libraryToggleViewDidTapAlbumsButton()
}

enum LibraryToggleViewState {
    case playlist, album
}

class LibraryToggleView: UIView {
    weak var delegate: LibraryToggleViewDelegate?
    
    var state: LibraryToggleViewState = .playlist {
        didSet {
            updateUnderlineFromState()
        }
    }
    
    var underlineConstraints = [NSLayoutConstraint]()
    
    private let playlistsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Playlists", for: .normal)
        button.setTitleColor(.label, for: .normal)
        
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Albums", for: .normal)
        button.setTitleColor(.label, for: .normal)
        
        return button
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primary
        
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 4, right: 8)
        stackView.axis = .horizontal
        stackView.spacing = 24
        
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        
        playlistsButton.addTarget(self, action: #selector(didTapPlaylistsButton), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbumsButton), for: .touchUpInside)
        
        stackView.addArrangedSubview(playlistsButton)
        stackView.addArrangedSubview(albumsButton)

        addSubview(stackView)
        addSubview(underlineView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateStateTo(_ state: LibraryToggleViewState) {
        self.state = state
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            underlineView.heightAnchor.constraint(equalToConstant: 2),
            underlineView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
        ])
        
        updateUnderlineFromState()
    }
    
    @objc private func didTapPlaylistsButton() {
        state = .playlist
        delegate?.libraryToggleViewDidTapPlaylistsButton()
    }
    
    @objc private func didTapAlbumsButton() {
        state = .album
        delegate?.libraryToggleViewDidTapAlbumsButton()
    }
    
    private func updateUnderlineFromState() {
        let focusedView = {
            switch state {
            case .playlist:
                return playlistsButton
            case .album:
                return albumsButton
            }
        }()
        
        NSLayoutConstraint.deactivate(underlineConstraints)
        
        underlineConstraints = [
            underlineView.leadingAnchor.constraint(equalTo: focusedView.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: focusedView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(underlineConstraints)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
