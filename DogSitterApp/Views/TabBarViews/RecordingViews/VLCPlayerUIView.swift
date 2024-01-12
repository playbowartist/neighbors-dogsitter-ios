
//  VLCPlayerUIView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 6/5/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.


import UIKit
import MobileVLCKit

class VLCPlayerUIView: UIView, VLCMediaPlayerDelegate {

    var vlcPlayer: VLCMediaPlayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        vlcPlayer = VLCMediaPlayer(options: ["--no-audio"])
        vlcPlayer?.drawable = self
        vlcPlayer?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func updateCameraUrl(cameraUrl: URL) {
        let media = VLCMedia(url: cameraUrl)
        vlcPlayer?.media = media
        vlcPlayer?.play()
    }
}
