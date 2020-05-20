//
//  VideoPlayerSwiftUIView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/20/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

struct VideoPlayerSwiftUIView: UIViewRepresentable {
    
    let cameraUrl: URL?
    func updateUIView(_ uiView: UIView, context: Context) { }
    func makeUIView(context: Context) -> UIView {
        return VideoPlayerUIView(cameraUrl: cameraUrl, frame: .zero)
    }
}
