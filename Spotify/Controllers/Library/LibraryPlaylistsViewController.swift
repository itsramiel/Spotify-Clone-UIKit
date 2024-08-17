//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by Rami Elwan on 15.08.24.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {
    
    var playlists = [Playlist]()
    var actionLabelView = {
        let view = ActionLabelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.configureWith(
            viewModel: ActionLabelViewViewModel(
                text: "You dont have any playlists yet!",
                actionTitle: "Create"
            )
        )
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemPink
        actionLabelView.delegate = self
        fetchPlaylists()
    }
    
    private func fetchPlaylists() {
        APIManager.shared.getCurrentUserPlaylists {[weak self] result in
            guard case let .success(playlists) = result else { return }
            
//            self?.playlists = playlists
            DispatchQueue.main.async { [weak self] in
                self?.updateUI()
            }
        }
    }
    
    private func updateUI(){
        if playlists.isEmpty {
            view.addSubview(actionLabelView)
            
            NSLayoutConstraint.activate([
                actionLabelView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                actionLabelView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            ])
        } else {
            
        }
    }
    
    func showCreatePlaylistAlert() {
        let alert = UIAlertController(
            title: "New Playlist",
            message: "Enter playlist name",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Playlist..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first else { return }
            guard let playlistName = field.text?.trimmingCharacters(in: .whitespaces),
                  playlistName.count > 0 else { return }
            
            APIManager.shared.createPlaylistWithName(playlistName) { [weak self] success in
                if success {
                    self?.fetchPlaylists()
                }
            }
        }))
        
        present(alert, animated: true)
    }
}

extension LibraryPlaylistsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        self.showCreatePlaylistAlert()
    }
}
