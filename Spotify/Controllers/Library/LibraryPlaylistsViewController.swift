//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by Rami Elwan on 15.08.24.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {
    
    var tableView: UITableView = {
        let view = UITableView()
        view.register(
            SearchResultTableViewCell.self,
            forCellReuseIdentifier: SearchResultTableViewCell.identifier
        )
        
        return view
    }()
    
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
        configureTableView()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchPlaylists() {
        APIManager.shared.getCurrentUserPlaylists {[weak self] result in
            guard case let .success(playlists) = result else { return }
            
            self?.playlists = playlists
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

extension LibraryPlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultTableViewCell.identifier,
            for: indexPath
        ) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        
        let playlist = playlists[indexPath.row]
        cell.configureWith(viewModel: SearchResultTableViewCellViewModel(
            artworkUrl: URL(string: playlist.images?.first?.url ?? ""),
            title: playlist.name,
            subtitle: playlist.owner.displayName ?? playlist.owner.id
        )
        )
        
        return cell
    }
    
}
