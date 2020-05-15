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
    
    var playerLayer = AVPlayerLayer()
    
    var body: some View {
        
        VStack {
            
            PlayerView(playerLayer: playerLayer)
            
            Button("Start Camera") {
                // need to re-set player into playerLayer
//                self.playerLayer.player?.play()
            }.padding()
            Button("Stop Camera") {
                self.playerLayer.player = nil
            }.padding()
            
        }
        
        
//        NavigationLink(destination: LiveVideoView()) {
//            Text("View Camera")
//        }
        .navigationBarTitle("Camera Control", displayMode: .inline)
    }
}

struct CameraControlView_Previews: PreviewProvider {
    static var previews: some View {
        CameraControlView()
    }
}



struct PlayerView: UIViewRepresentable {
    
    let playerLayer: AVPlayerLayer
    
//    init(playerLayer: AVPlayerLayer) {
//        self.playerLayer = playerLayer
//    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(playerLayer: playerLayer, frame: .zero)
    }
}

class PlayerUIView: UIView {
    private let playerLayer: AVPlayerLayer
    
    init(playerLayer: AVPlayerLayer, frame: CGRect) {
        self.playerLayer = playerLayer
        super.init(frame: frame)
        
        let session = URLSession(configuration: .default)
        let httpService = HttpService(session: session)
        let networkingAPI = NetworkingAPI(httpService: httpService)
        
        networkingAPI.getCameraUrl { (url) in
            guard let url = url else { return }
            let player = AVPlayer(url: url)
            player.play()
            self.playerLayer.player = player
            DispatchQueue.main.async {
                self.layer.addSublayer(self.playerLayer)
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
