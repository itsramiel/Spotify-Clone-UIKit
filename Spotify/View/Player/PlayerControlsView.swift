//
//  PlayersControlView.swift
//  Spotify
//
//  Created by Rami Elwan on 13.08.24.
//

import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func playerControlViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
    func playerControlViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlViewDidTapForwardButton(_ playerControlsView: PlayerControlsView)
}

class PlayerControlsView: UIView {
    weak var delegate: PlayerControlsViewDelegate?
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = 0.5
        
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.text = "Call me maybe"
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .secondaryLabel
        label.text = "Carly Rae Jepsen"

        return label
    }()

    private let labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        
        return stack
    }()
    
    private static let BUTTON_SIZE: CGFloat = 34
    
    private let backwardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.setImage(
            UIImage(
                systemName: "backward.fill",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: PlayerControlsView.BUTTON_SIZE
                )
            ),
            for: .normal
        )
        
        button.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.setImage(
            UIImage(
                systemName: "forward.fill",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: PlayerControlsView.BUTTON_SIZE
                )
            ),
            for: .normal
        )
        
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.setImage(
            UIImage(
                systemName: "pause.fill",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: PlayerControlsView.BUTTON_SIZE
                )
            ),
            for: .normal
        )
        
        return button
    }()
    
    private let controlsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        
        return stack
    }()
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 48
        
        return stack
    }()
    
    private let container: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        backwardButton.addTarget(self, action: #selector(didTapBackwardButton), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(didTapForwardButton), for: .touchUpInside)

        addSubview(container)
        container.addArrangedSubview(mainStack)
        
        labelsStack.addArrangedSubview(nameLabel)
        labelsStack.addArrangedSubview(subtitleLabel)
        mainStack.addArrangedSubview(labelsStack)
        mainStack.addArrangedSubview(volumeSlider)
        
        controlsStack.addArrangedSubview(backwardButton)
        controlsStack.addArrangedSubview(playPauseButton)
        controlsStack.addArrangedSubview(forwardButton)
        mainStack.addArrangedSubview(controlsStack)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapPlayPauseButton() {
        delegate?.playerControlViewDidTapForwardButton(self)
    }
    
    @objc private func didTapBackwardButton() {
        delegate?.playerControlViewDidTapBackwardButton(self)
    }
    
    @objc private func didTapForwardButton() {
        delegate?.playerControlViewDidTapForwardButton(self)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.rightAnchor.constraint(equalTo: rightAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
