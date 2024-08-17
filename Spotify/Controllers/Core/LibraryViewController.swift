//
//  LibraryViewController.swift
//  Spotify
//
//  Created by Rami Elwan on 23.07.24.
//

import UIKit

class LibraryViewController: UIViewController {
    private let playlistVC = LibraryPlaylistsViewController()
    private let albumVC = LibraryAlbumsViewController()
    private let libraryToggleView = LibraryToggleView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.spacing = 8
        
        return stackview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureSubviews()
        setupConstraints()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        switch libraryToggleView.state {
        case .playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(didTapAdd)
            )
        case .album:
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc private func didTapAdd() {
        playlistVC.showCreatePlaylistAlert()
    }
    
    private func configureSubviews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        playlistVC.view.translatesAutoresizingMaskIntoConstraints = false
        albumVC.view.translatesAutoresizingMaskIntoConstraints = false
        libraryToggleView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        libraryToggleView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        stackView.addArrangedSubview(libraryToggleView)
        libraryToggleView.delegate = self
        
        stackView.addArrangedSubview(scrollView)

        scrollView.backgroundColor = .yellow
        scrollView.delegate = self
        
        scrollView.addSubview(playlistVC.view)
        scrollView.addSubview(albumVC.view)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            playlistVC.view.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor),
            playlistVC.view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            playlistVC.view.widthAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.widthAnchor),
            playlistVC.view.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor),
            
            albumVC.view.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor),
            albumVC.view.leadingAnchor.constraint(equalTo: playlistVC.view.trailingAnchor),
            albumVC.view.widthAnchor.constraint(equalTo: playlistVC.view.widthAnchor),
            albumVC.view.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor),
            
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 2),
            scrollView.contentLayoutGuide.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
}

extension LibraryViewController: UIScrollViewDelegate {
    func updateUIFromScrollView() {
        let x = scrollView.contentOffset.x
        libraryToggleView.updateStateTo(x == 0 ? .playlist : .album)
        configureNavigationBar()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateUIFromScrollView()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        updateUIFromScrollView()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateUIFromScrollView()
    }
}

extension LibraryViewController: LibraryToggleViewDelegate {
    func libraryToggleViewDidTapPlaylistsButton() {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func libraryToggleViewDidTapAlbumsButton() {
        scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width/2, y: 0), animated: true)
    }
}
