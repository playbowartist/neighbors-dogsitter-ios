//
//  CameraControlView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/3/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import UIKit
import SwiftUI
import AVFoundation

struct CameraControlView: View {
    
    var cameraControlVM = CameraControlViewModel()
    lazy var cameraControl_Interactor = CameraControl_Interactor(cameraControlVM: cameraControlVM)
    var playerLayer = AVPlayerLayer()
    
    func returnMutableCameraControl_Interactor() -> CameraControl_Interactor {
        var mutableSelf = self
        return mutableSelf.cameraControl_Interactor
    }
    
    var body: some View {
        
        VStack {
            
            // TODO: Show the PlayerView based on whether cameraUrl is nil or not
            PlayerView(cameraUrl: self.cameraControlVM.cameraUrl, playerLayer: playerLayer)
            
            Button("Start Camera") {
                self.returnMutableCameraControl_Interactor()
                    .startRecording(networkingAPI: nil) {
                        
                        // TODO: Observe the change in cameraUrl in VM to render video, instead of manually re-setting the videoPlayer
                        
                        if let url = self.cameraControlVM.cameraUrl {
                            let player = AVPlayer(url: url)
                            player.play()
                            self.playerLayer.player = player
                        }
                }
            }.padding()
            Button("Stop Camera") {
                self.playerLayer.player = nil
            }.padding()
            
        }
        .navigationBarTitle("Camera Control", displayMode: .inline)
    }
}

struct CameraControlView_Previews: PreviewProvider {
    static var previews: some View {
        CameraControlView()
    }
}

struct PlayerView: UIViewRepresentable {
    
    let cameraUrl: URL?
    let playerLayer: AVPlayerLayer
    
//    init(playerLayer: AVPlayerLayer) {
//        self.playerLayer = playerLayer
//    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(cameraUrl: cameraUrl, playerLayer: playerLayer, frame: .zero)
    }
}

class PlayerUIView: UIView {
    
    private let cameraUrl: URL?
    private let playerLayer: AVPlayerLayer
    
    init(cameraUrl: URL?, playerLayer: AVPlayerLayer, frame: CGRect) {
        self.cameraUrl = cameraUrl
        self.playerLayer = playerLayer
        super.init(frame: frame)
        self.layer.addSublayer(self.playerLayer)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
