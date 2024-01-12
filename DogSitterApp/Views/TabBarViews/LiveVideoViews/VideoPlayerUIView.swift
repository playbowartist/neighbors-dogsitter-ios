//
//  VideoPlayerUIView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/20/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import UIKit
import Combine
import AVFoundation

//class VideoPlayerUIView: UIView {
//
//    private let playerLayer = AVPlayerLayer()
//
//    convenience init(videoPlayer: AVPlayer, frame: CGRect) {
//        self.init(frame: frame)
//
////            let asset = AVURLAsset(url: cameraUrl)
////            let playerItem = AVPlayerItem(asset: asset)
//
////            let player = Player(playerItem: playerItem)
////            let player = AVPlayer(playerItem: playerItem)
//
////            player.playItem()
//        self.playerLayer.player = videoPlayer
//        self.layer.addSublayer(self.playerLayer)
//    }
//
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.playerLayer.frame = self.bounds
//    }
//}

class VideoPlayerUIView: UIView {

    private var playerLayer = AVPlayerLayer()
    
    convenience init(videoPlayer: AVPlayer, frame: CGRect) {
        self.init(frame: frame)
        self.playerLayer.player = videoPlayer
        self.layer.addSublayer(self.playerLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer.frame = self.bounds
    }
}


//class PlayerItemObserver {
//
//    @Published var currentStatus: AVPlayer.TimeControlStatus?
//    private var itemObservation: AnyCancellable?
//
//    init(player: AVPlayer) {
//        itemObservation = player.publisher(for: \.timeControlStatus).sink { newStatus in
//            self.currentStatus = newStatus
//        }
//    }
//}

//class VideoPlayer: AVPlayer, ObservableObject {
//
//    @Published var isPlaying: Bool = false
//    
//    override init(playerItem: AVPlayerItem?) {
//        super.init()
//        registerObservers()
//        self.play()
//        print("timeControlStatus:", self.timeControlStatus.rawValue)
//    }
//    
//    private func registerObservers() {
//        self.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
//            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
//            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
//            if newStatus != oldStatus {
//                DispatchQueue.main.async {[weak self] in
//                    if newStatus == .playing {
//                        self?.isPlaying = true
//                    } else {
//                        self?.isPlaying = false
//                    }
//                }
//            }
//        }
//    }
//}
//
//class PlayerItemObserver {
//
//    let controlStatusChanged = PassthroughSubject<AVPlayer.TimeControlStatus, Never>()
//    private var itemObservation: NSKeyValueObservation?
//
//    init(player: AVPlayer) {
//
//        itemObservation = player.observe(\.timeControlStatus) { [weak self] player, change in
//            guard let self = self else { return }
//            self.controlStatusChanged.send(player.timeControlStatus)
//        }
//    }
//
//    deinit {
//        if let observer = itemObservation {
//            observer.invalidate()
//        }
//    }
//}
