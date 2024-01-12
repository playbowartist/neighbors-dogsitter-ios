//
//  DogSitterLiveView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/3/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct DogSitterLiveView: View {
    
    @EnvironmentObject var appState: AppState
    @ObservedObject var dogsitterLiveVM = DogSitterLiveViewModel()
    let authAPI = AuthenticationAPI()
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                // Observe nowRecording flag to determine whether live video should be displayed
                if self.dogsitterLiveVM.nowRecording &&
                    self.dogsitterLiveVM.cameraUrl != nil &&
                    self.dogsitterLiveVM.videoPlayer != nil {
                    VideoPlayerSwiftUIView(videoPlayer: self.dogsitterLiveVM.videoPlayer!)
                        .border(Color(.systemGray6), width: 1.0)
                        .aspectRatio(16.0/9.0, contentMode: .fit)
                } else {
                    ZStack {
                        Rectangle()
                            .fill(Color(.systemGray6))
                            .aspectRatio(16.0/9.0, contentMode: .fit)
                        Text("Not Streaming")
                    }
                }
                
                // TODO: Play with button colors
                HStack {
                    Spacer()
                    ///
                    Button(action: {
                        if let firebaseUser = Auth.auth().currentUser {
                            self.dogsitterLiveVM.startStreamAndRecording(user: firebaseUser, networkingAPI: nil, completionHandler: nil)
                        }
                    }) {
                        VStack {
                            Image(systemName: "video.circle.fill")
                                .font(.system(size: 48.0))
                            Text("Start Stream")
                                .padding(.top)
                        }
                    }
                    .opacity(self.dogsitterLiveVM.disableStartButton ? 0.25 : 1.0)
                    .disabled(self.dogsitterLiveVM.disableStartButton)
                    ///
                    Spacer()
                    ///
                    Button(action: {
                        if let firebaseUser = Auth.auth().currentUser {
                            self.dogsitterLiveVM.setIsRecording(to: false, user: firebaseUser)
                            // TODO: Also stop recording via Angelcam
                        }
                    }) {
                        VStack {
                            Image(systemName: "stop.circle")
                                .font(.system(size: 48.0))
                            Text("Stop Stream")
                                .padding(.top)
                        }
                    }
                    .opacity(self.dogsitterLiveVM.disableStopButton ? 0.25 : 1.0)
                    .disabled(self.dogsitterLiveVM.disableStopButton)
                    ///
                    Spacer()
                }
                .padding(.top, 25.0)
                
                Spacer()
            }
            .navigationBarTitle("Camera Control Center", displayMode: .inline)
//            .navigationBarItems(trailing: Button("Logout") {
//
//                let logoutError = self.authAPI.logout()
//                if logoutError == nil {
//                    self.appState.userData = nil
//                    self.appState.loginDestination = .firebaseAuthentication
//                } else {
//                    // Display popup indicating logout unsuccessful
//                }
//            })
        }
    }
}

struct DogSitterLiveView_Previews: PreviewProvider {
    static var previews: some View {
        DogSitterLiveView()
    }
}

