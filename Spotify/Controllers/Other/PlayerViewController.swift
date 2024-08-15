//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Rami Elwan on 23.07.24.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapBackward()
    func didTapForward()
    func didSliderChange(_ value: Float)
}

class PlayerViewController: UIViewController {
    weak var datasource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBlue
        
        return imageView
    }()
    
    private let controlsView: PlayerControlsView = {
        let view = PlayerControlsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = datasource?.title
        
        controlsView.delegate = self
        controlsView.datasource = self
        
        view.addSubview(mainStack)
        configureWithDatasource()
        configureBarButtons()
        setupConstraints()
    }
    
    private func configureWithDatasource() {
        imageView.sd_setImage(with: datasource?.imageUrl)
        if let title = datasource?.title, let subtitle = datasource?.subtitle, let volume = datasource?.volume {
            controlsView.configure(with: PlayerControlsViewViewModel(title: title, subtitle: subtitle, volume: volume))
        }
    }
    
    private func setupConstraints() {
        mainStack.addArrangedSubview(imageView)
        mainStack.addArrangedSubview(controlsView)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func configureBarButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapAction)
        )
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAction() {
        // Action
    }

}

extension PlayerViewController: PlayerControlsViewDelegate {
    func playerControlViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPause()
    }
    
    func playerControlViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapBackward()
        configureWithDatasource()
    }
    
    func playerControlViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapForward()
        configureWithDatasource()
    }
    
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSliderChange(value)
    }
}

extension PlayerViewController: PlayerControlsViewDataSource {
    var isPlaying: Bool? {
        return datasource?.isPlaying
    }
    
    var volume: Float? {
        datasource?.volume
    }
}
