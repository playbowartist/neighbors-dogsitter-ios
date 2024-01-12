//
//  LiveVideoView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 8/18/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI
import AVFoundation

struct LiveVideoView: View {
    
    @EnvironmentObject var appState: AppState
//    let playerObserver = PlayerItemObserver(player:
//        VideoPlayer(playerItem:
//            AVPlayerItem(url:
//                URL(string: "https://m1-na8.angelcam.com/cameras/98280/streams/hls/playlist.m3u8?token=eyJjYW1lcmFfaWQiOiI5ODI4MCIsInRpbWUiOjE2MDMyODM5MTk4ODM3MzksInRpbWVvdXQiOjM2MDB9%2E1ce86a877c45667d345015c7428e879f4b8cea2a242d55dc9dc937dcd87975aa")!)))
    
    var body: some View {
        
        VStack {
            if self.appState.userData?.userType == .dogsitter {
                DogSitterLiveView()
            } else {
                CustomerLiveView()
            }
        }
        
    }
}


struct LiveVideoView_Previews: PreviewProvider {
    static var previews: some View {
        LiveVideoView()
    }
}
