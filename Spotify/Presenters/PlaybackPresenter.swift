//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Rami Elwan on 12.08.24.
//

import UIKit

final class PlaybackPresenter {
    static func startPlayback(
        from viewController: UIViewController,
        tracks: [Track]
    ){
        let vc = PlayerViewController()
        viewController.present(vc, animated: true)
    }
}
