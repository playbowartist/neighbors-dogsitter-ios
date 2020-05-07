//
//  LiveVideoView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/3/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftUI

// Spy

struct LiveVideoView: View {
    var body: some View {
        PlayerView()
        .navigationBarTitle("Live Video", displayMode: .inline)
    }
}

struct LiveVideoView_Previews: PreviewProvider {
    static var previews: some View {
        LiveVideoView()
    }
}

struct PlayerView: UIViewRepresentable {
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(frame: .zero)
    }
}

class PlayerUIView: UIView {
  private let playerLayer = AVPlayerLayer()
  override init(frame: CGRect) {
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
