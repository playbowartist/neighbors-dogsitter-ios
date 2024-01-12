//
//  VideoPlayerViewController.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 11/9/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import AVKit
import SwiftUI

struct VideoPlayerViewController: UIViewControllerRepresentable {
    
    var videoURL: URL
    
    private var player: AVPlayer {
        return AVPlayer(url: videoURL)
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller =  AVPlayerViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.showsPlaybackControls = false
        controller.player = player
        controller.player?.play()
        return controller
    }
    
    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        
    }
    
}

