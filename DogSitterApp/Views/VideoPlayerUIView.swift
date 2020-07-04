//
//  VideoPlayerUIView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/20/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerUIView: UIView {

    private let playerLayer = AVPlayerLayer()
    
    convenience init(cameraUrl: URL?, frame: CGRect) {
        self.init(frame: frame)
//        if let cameraUrl = cameraUrl {
//            let player = AVPlayer(url: cameraUrl)
//            player.play()
//            self.playerLayer.player = player
//            self.layer.addSublayer(self.playerLayer)
//        }
        
        if let cameraUrl = cameraUrl {
            
            print("cameraUrl inside PlayerView: ", cameraUrl)
            let asset = AVURLAsset(url: cameraUrl)
            
//            let asset = AVAsset(url: cameraUrl)
            
            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playerItem)
            player.play()
            self.playerLayer.player = player
            self.layer.addSublayer(self.playerLayer)
        }
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer.frame = self.bounds
    }
}
