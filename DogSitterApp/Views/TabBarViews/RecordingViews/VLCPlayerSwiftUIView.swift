//
//  VLCPlayerSwiftUIView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 6/5/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI
import AVFoundation

struct VLCPlayerSwiftUIView: UIViewRepresentable {
    
    var videoURL: URL?
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let cameraUrl = videoURL,
            let vlcPlayerUIView = uiView as? VLCPlayerUIView {
//           let vlcPlayerUIView = uiView as? VideoPlayerUIView {
            vlcPlayerUIView.updateCameraUrl(cameraUrl: cameraUrl)
        }
    }
    
    func makeUIView(context: Context) -> UIView {
//        return VideoPlayerUIView()
        return VLCPlayerUIView(frame: .infinite)
    }
}
