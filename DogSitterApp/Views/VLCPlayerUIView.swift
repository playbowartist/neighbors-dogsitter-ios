//
//  VLCPlayerUIView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 6/5/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import UIKit
import MobileVLCKit

class VLCPlayerUIView: UIView, VLCMediaPlayerDelegate {

    var vlcPlayer: VLCMediaPlayer = VLCMediaPlayer()
    
//    convenience init(cameraUrl: URL?, frame: CGRect) {
//        self.init(frame: frame)
//    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func updateCameraUrl(cameraUrl: URL) {
        let media = VLCMedia(url: cameraUrl)
        vlcPlayer.media = media
        vlcPlayer.drawable = self
        vlcPlayer.delegate = self
        vlcPlayer.play()
    }
    
}
