//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Rami Elwan on 23.07.24.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        
        return button
    }()
    
    private let image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(resource: .spotify)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
            
        view.backgroundColor = .bg
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(signInButton)
        view.addSubview(image)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            signInButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            signInButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            signInButton.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            
            image.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            image.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            image.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            image.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 24.35/89)
        ])
    }
    
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            self?.handleSignIn(success: success)
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleSignIn(success isSuccess: Bool) {
        guard isSuccess else {
            let alert = UIAlertController(title: "OOps", message: "Somethiing went wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            
            present(alert, animated: true)
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
}
