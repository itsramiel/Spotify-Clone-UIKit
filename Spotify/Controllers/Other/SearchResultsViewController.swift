//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by Rami Elwan on 23.07.24.
//

import UIKit
import SafariServices

struct SearchSection {
    let title: String
    let data: [SearchResult]
}

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapSearchResult(_ searchResult: SearchResult)
}

class SearchResultsViewController: UIViewController {
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private var data = [SearchSection]()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        tableView.isHidden = true
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
    }
    
    func update(with data: [SearchSection]) {
        self.data = data
        tableView.reloadData()
        tableView.isHidden = data.isEmpty || data.allSatisfy({$0.data.isEmpty})
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier) as? SearchResultTableViewCell else {
            fatalError()
        }
        
        let searchResult = data[indexPath.section].data[indexPath.row]
        
        let viewModel = {
            switch searchResult {
            case .artist(model: let model):
                let subtitle: String? = {
                    if let followersCount = model.followers?.total {
                        return "Followers: \(followersCount)"
                    }
                    
                    return nil
                }()
                return SearchResultTableViewCellViewModel(artworkUrl: URL(string: model.images?.first?.url ?? ""), title: model.name, subtitle: subtitle)
            case .album(model: let model):
                return SearchResultTableViewCellViewModel(artworkUrl: URL(string: model.images.first?.url ?? ""), title: model.name, subtitle: model.artists.map({$0.name}).joined(separator: ", "))
            case .track(model: let model):
                return SearchResultTableViewCellViewModel(artworkUrl: URL(string: model.album?.images.first?.url ?? ""), title: model.name, subtitle: model.artists.map({$0.name}).joined(separator: ", "))
            case .playlist(model: let model):
                return SearchResultTableViewCellViewModel(artworkUrl: URL(string: model.images.first?.url ?? ""), title: model.name, subtitle: model.owner.displayName)
            }
        }()
        
        cell.configureWith(viewModel: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = data[indexPath.section].data[indexPath.row]
        
        delegate?.didTapSearchResult(item)
    }
}
