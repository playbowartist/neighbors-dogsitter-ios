//
//  VideoPlayerSwiftUIView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/20/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI
import AVFoundation

struct VideoPlayerSwiftUIView: UIViewRepresentable {
    
//    let cameraUrl: URL?
    let videoPlayer: AVPlayer
    func updateUIView(_ uiView: UIView, context: Context) { }
    func makeUIView(context: Context) -> UIView {
        return VideoPlayerUIView(videoPlayer: videoPlayer, frame: .zero)
    }
}
