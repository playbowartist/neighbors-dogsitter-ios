//
//  VLCPlayerSwiftUIView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 6/5/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

struct VLCPlayerSwiftUIView: UIViewRepresentable {
    
    var cameraUrl: URL?
    
    func updateUIView(_ uiView: UIView, context: Context) {
        print("updating UIViewRepresentable")
        if let cameraUrl = cameraUrl,
            let vlcPlayerUIView = uiView as? VLCPlayerUIView {
            vlcPlayerUIView.updateCameraUrl(cameraUrl: cameraUrl)
        }
    }
    
    func makeUIView(context: Context) -> UIView {
        print("make new UIView")
        return VLCPlayerUIView(frame: .zero)
    }
}
