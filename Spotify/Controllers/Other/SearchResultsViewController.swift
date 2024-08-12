//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by Rami Elwan on 23.07.24.
//

import UIKit

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let searchResult = data[indexPath.section].data[indexPath.row]
        
        cell?.textLabel?.text = {
            switch searchResult {
            case .artist(model: let model):
                return model.name
            case .album(model: let model):
                return model.name
            case .track(model: let model):
                return model.name
            case .playlist(model: let model):
                return model.name
            }
        }()
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = data[indexPath.section].data[indexPath.row]
        
        delegate?.didTapSearchResult(item)
    }
    
}
