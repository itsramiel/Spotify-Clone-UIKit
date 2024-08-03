//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Rami Elwan on 23.07.24.
//

import SDWebImage
import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true

        return tableView
    }()

    var infos: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        view.backgroundColor = .systemBackground
        fetchUser()
    }

    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }

    private func fetchUser() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        APIManager.shared.getCurrentUserProfile(completion: { [weak self] result in
            guard case let .success(userProfile) = result else {
                self?.onFailedToGetProfile()
                return
            }

            self?.updateUI(with: userProfile)
        })
    }

    private func updateUI(with profile: UserProfile) {
        tableView.isHidden = false

        infos.append("Full Name: \(profile.displayName)")
        infos.append("User ID: \(profile.id)")
        infos.append("Plan: \(profile.product)")

        if profile.images.count >= 1 {
            let stringUrl = profile.images[1].url
            createTableHeader(with: stringUrl)
        }

        tableView.reloadData()
    }

    private func createTableHeader(with stringUrl: String) {
        guard let url = URL(string: stringUrl) else { return }

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: (2 / 3) * view.width))

        let imageSize: CGFloat = 0.7 * headerView.height
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: url)

        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize / 2

        DispatchQueue.main.async { [weak self] in
            self?.tableView.tableHeaderView = headerView
        }
    }

    private func onFailedToGetProfile() {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return infos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = infos[indexPath.row]

        return cell
    }
}
