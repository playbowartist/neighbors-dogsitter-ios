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
    
    @EnvironmentObject var appState: AppState
    @ObservedObject var recordingListVM: RecordingListViewModel
    @State var shouldObserveRecordedClips: Bool = true
    
    var body: some View {
        
        VStack {
            
            if self.recordingListVM.videoUrl != nil {
                ZStack {
                    VLCPlayerSwiftUIView(videoURL: self.recordingListVM.videoUrl)
                        .border(Color(.systemGray6), width: 1.0)
                        .aspectRatio(CGSize(width: 16.0, height: 9.0), contentMode: .fit)
                }
                .aspectRatio(16.0/9.0, contentMode: .fit)
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color(.systemGray6))
                        .border(Color(.systemGray6), width: 1.0)
                        .aspectRatio(16.0/9.0, contentMode: .fit)
                    Text("Please select a video")
                }
            }
            
            List {
                ForEach(self.recordingListVM.videoList, id: \.id) { video in
                    VStack {
                        ZStack {
                            Image(uiImage: video.thumbnail)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .aspectRatio(16.0/9.0, contentMode: .fit)

                        Button {
                            self.recordingListVM.setRecordingSelected(clip_id: video.clip_id, networkingAPI: nil)
                        } label: {
                            HStack {
                                Image(systemName: "video.circle")
                                    .font(.largeTitle)
                                    .padding(.leading)
                                    .padding(.trailing)
                                VStack {
                                    HStack {
                                        Text(video.dateComponents[0])   // Date
                                        Spacer()
                                    }
                                    HStack {
                                        Text(video.dateComponents[1])   // Time
                                            .font(.footnote)
                                            .padding(.trailing)
                                        Text(video.formattedTimeInterval)   // Duration
                                            .font(.footnote)
                                            .padding(.leading)
                                        Spacer()
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .padding(.bottom, 25.0)
                }
            }
            .padding(.top)
            
        }
        .onAppear {
            self.recordingListVM.videoUrl = nil
//            self.recordingListVM.userData = self.appState.userData
            if self.shouldObserveRecordedClips {
                self.recordingListVM.observeRecordedClips(userData: self.appState.userData)
                self.shouldObserveRecordedClips = false
            }
        }
        .onDisappear {
//            self.recordingListVM.videoUrl = nil
        }
    }
}

//struct RecordingListView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordingListView()
//    }
//}
