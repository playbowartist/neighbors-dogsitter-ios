//
//  RecordingListView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/24/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import UIKit
import SwiftUI

struct RecordingListView: View {
    
    @ObservedObject var recordingListVM: RecordingListViewModel = RecordingListViewModel()
    lazy var recordingListInteractor = RecordingListInteractor(recordingListVM: recordingListVM)
    
    init(recordingListVM: RecordingListViewModel) {
//        self.recordingListVM = recordingListVM
        self.mutableRecordingListInteractor().getRecordingList(networkingAPI: nil, completionHandler: nil)
    }
    
    func mutableRecordingListInteractor() -> RecordingListInteractor {
        var mutableSelf = self
        return mutableSelf.recordingListInteractor
    }
    
    var body: some View {
        
        VStack {
            
            VLCPlayerSwiftUIView(cameraUrl: self.recordingListVM.videoUrl)
                .border(Color.blue, width: 2.0)
                .aspectRatio(CGSize(width: 16, height: 9), contentMode: .fit)
            
            if recordingListVM.isPortrait == true && recordingListVM.videoList != nil {
                List {
                    ForEach(recordingListVM.videoList!, id: \.id) { video in
                        Button(video.name!) {
                            self.mutableRecordingListInteractor().setRecordingSelected(videoUrl: video.url)
                        }
                    }
                }
            }
        }
        .onAppear {
            let isPortrait = UIDevice.current.orientation.isPortrait
            self.recordingListVM.isPortrait = isPortrait
            print("isPortrait in onAppear: ", UIDevice.current.orientation.rawValue)
        }
    }
}











struct RecordingListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingListView(recordingListVM: RecordingListViewModel())
    }
}
