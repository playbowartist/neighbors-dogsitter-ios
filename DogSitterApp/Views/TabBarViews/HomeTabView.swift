//
//  HomeTabView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 8/18/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct HomeTabView: View {
    
    @EnvironmentObject var appState: AppState
//    @Binding var currentTab: TabSelection
    
    @ObservedObject var recordingListVM: RecordingListViewModel
    
    var body: some View {
        
        ZStack {
            // TODO: Test whether notifications will properly jump to LiveView
            TabView(selection: self.$appState.tabSelection) {
                OverallCalendarView()
                    .padding()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                    .tag(TabSelection.calendarView)
                
                if self.appState.userData?.userType == .customer {
                    ReserveDatesView()
                        .padding()
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("Reserve Dates")
                        }
                        .tag(TabSelection.reserveDatesView)
                }
                
                LiveVideoView()
                    .tabItem {
                        if self.appState.userData?.userType == .dogsitter {
                            Image(systemName: "speedometer")
                            Text("Camera Control")
                        } else {
                            Image(systemName: "video")
                            Text("Live Video")
                        }
                    }
                    .tag(TabSelection.liveVideoView)
                
                RecordingListView(recordingListVM: self.recordingListVM)
                    .tabItem {
                        Image(systemName: "play.rectangle")
                        Text("Recorded Clips")
                    }
                    .tag(TabSelection.recordedClipsView)
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(TabSelection.settingsView)
            }
            
            if self.appState.showLiveViewFullscreen &&
                self.appState.videoURL != nil {
                ZStack {
                    FullscreenVideoSwiftUIView(videoURL: self.appState.videoURL!)
                    VStack {
                        HStack {
                            Button {
                                self.appState.showLiveViewFullscreen = false
                                self.appState.videoURL = nil
                            } label: {
                                Image(systemName: "arrow.down.right.and.arrow.up.left")
                                    .font(Font.system(.headline))
                                    .padding(10.0)
                                    .background(Color(.systemGray).opacity(0.75))
                                    .foregroundColor(Color.primary)
                                    .cornerRadius(5.0)
                                    .padding()
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .zIndex(1.0)
            }
        }
    }
}


//struct HomeTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeTabView()
//    }
//}
