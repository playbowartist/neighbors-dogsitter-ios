//
//  FullscreenVideoSwiftUIView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 11/9/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

struct FullscreenVideoSwiftUIView: View {
    
    var videoURL: URL
    
    var body: some View {
        VStack {
            VideoPlayerViewController(videoURL: self.videoURL)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            DispatchQueue.main.async {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.landscape
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                UITabBarController.attemptRotationToDeviceOrientation()
            }
        }
        .onDisappear {
            DispatchQueue.main.async {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UITabBarController.attemptRotationToDeviceOrientation()
            }
        }
        
    }
}

