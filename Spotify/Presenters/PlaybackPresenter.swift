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
        guard let firstTrack = tracks.first else { return }
        let vc = PlayerViewController(headerTitle: firstTrack.name)
        let nc = UINavigationController(rootViewController: vc)
        viewController.present(nc, animated: true)
    }
}
