//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by Rami Elwan on 15.08.24.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {
    private var observer: NSObjectProtocol?
    var albums = [Album]()
    private let noAlbumsView: ActionLabelView = {
        let view = ActionLabelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.configureWith(
            viewModel: ActionLabelViewViewModel(
                text: "You don't have any saved albums",
                actionTitle: "Browse"
            )
        )
        view.isHidden = true
        
        return view
    }()
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(
            SearchResultTableViewCell.self,
            forCellReuseIdentifier: SearchResultTableViewCell.identifier
        )
        view.isHidden = true
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        view.addSubview(noAlbumsView)
        noAlbumsView.delegate = self
        
        setupNotificationObserver()
        setupTableView()
        setupConstrains()
        fetchData()
    }
    
    private func setupNotificationObserver() {
        observer = NotificationCenter.default.addObserver(
            forName: .albumSavedNotification,
            object: nil,
            queue: .main,
            using: {[weak self] _ in
                self?.fetchData()
            }
        )
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            noAlbumsView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            noAlbumsView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            noAlbumsView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
            noAlbumsView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
            noAlbumsView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor),
            noAlbumsView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchData() {
        APIManager.shared.getUserSavedAlbums { [weak self] result in
            guard case let .success(albums) = result else {
                return
            }
            
            self?.albums = albums
            print(albums.count)
            DispatchQueue.main.async {
                self?.updateUI()
                self?.tableView.reloadData()
            }
        }
    }
    
    public func updateUI() {
        let hasData = self.albums.count > 0
            self.tableView.isHidden = !hasData
            self.noAlbumsView.isHidden = hasData
    }
}

extension LibraryAlbumsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }
}

extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultTableViewCell.identifier,
            for: indexPath
        ) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        
        let album = albums[indexPath.row]
        cell.configureWith(
            viewModel: SearchResultTableViewCellViewModel(
                artworkUrl: URL(string: album.images.first?.url ?? ""),
                title: album.name,
                subtitle: album.artists.map({$0.name}).joined(separator: ", ")
            )
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticsManager.shared.select()
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = AlbumViewController(album: albums[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}
