//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Rami Elwan on 12.08.24.
//

import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var title: String? { get }
    var subtitle: String? { get }
    var imageUrl: URL? { get }
    var isPlaying: Bool? { get }
    var volume: Float? { get }
}

final class PlaybackPresenter {
    static let shared = PlaybackPresenter()
    
    private var tracks = [Track]()
    private var playingTrackIndex: Int? = nil
    private var track: Track? {
        guard let playingTrackIndex else { return nil }
        
        return tracks[playingTrackIndex]
    }

    var player: AVPlayer?
    
    private var playingTrack: Track? {
        guard let playingTrackIndex, playingTrackIndex >= 0 else {
            return nil
        }
        
        return tracks[playingTrackIndex]
    }
    
    func startPlayback(
        from viewController: UIViewController,
        tracks: [Track]
    ){
        self.tracks = tracks
        self.playingTrackIndex = 0
        
        guard let playingTrack, let trackUrl = URL(string: playingTrack.previewUrl ?? "") else { return }
        
        player = AVPlayer(url: trackUrl)
        player?.volume = 0.1
        
        let vc = PlayerViewController()
        vc.datasource = self
        vc.delegate = self
        
        let nc = UINavigationController(rootViewController: vc)
        viewController.present(nc, animated: true, completion: {[weak self] in
            self?.player?.play()
        })
    }
}

extension PlaybackPresenter: PlayerDataSource {
    var title: String? {
        playingTrack?.name
    }
    
    var subtitle: String? {
        playingTrack?.artists.map({$0.name}).joined(separator: ", ")
    }
    
    var imageUrl: URL? {
        return URL(string: playingTrack?.album?.images.first?.url ?? "")
    }
    
    var isPlaying: Bool? {
        return player?.timeControlStatus != .paused
    }
    
    var volume: Float? {
        player?.volume
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didTapPlayPause() {
        switch player?.timeControlStatus {
        case .paused:
            player?.play()
        case .playing:
            player?.pause()
        default:
            break
        }
    }
    
    func didTapBackward() {
        while true {
            guard var playingTrackIndex else { break }
            playingTrackIndex = playingTrackIndex != 0 ? playingTrackIndex - 1: tracks.count - 1
            self.playingTrackIndex = playingTrackIndex

            let url = URL(string: track?.previewUrl ?? "")
            guard let url else { continue }
            player?.replaceCurrentItem(with: AVPlayerItem(url: url))
            break
        }
    }
    
    func didTapForward() {
        
        while true {
            guard var playingTrackIndex else { break }
            playingTrackIndex = playingTrackIndex == tracks.count - 1 ? 0: playingTrackIndex + 1
            self.playingTrackIndex = playingTrackIndex
            
            let url = URL(string: track?.previewUrl ?? "")
            guard let url else { continue }
            player?.replaceCurrentItem(with: AVPlayerItem(url: url))
            break
        }
    }
    
    func didSliderChange(_ value: Float) {
        player?.volume = value
    }
}
