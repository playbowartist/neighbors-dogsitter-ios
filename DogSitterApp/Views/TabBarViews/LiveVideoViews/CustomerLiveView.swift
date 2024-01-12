//
//  CustomerLiveView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 10/14/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct CustomerLiveView: View {
    
    @EnvironmentObject var appState: AppState
    @ObservedObject var customerLiveVM = CustomerLiveViewModel()
    @State var fullscreen: Bool = false
    
    var body: some View {
        
        VStack {
            if self.customerLiveVM.videoPlayer != nil &&
                self.customerLiveVM.nowRecording {
                ZStack {
                    VideoPlayerSwiftUIView(videoPlayer: self.customerLiveVM.videoPlayer!)
                        .border(Color(.systemGray6), width: 1.0)
                        .aspectRatio(16.0/9.0, contentMode: .fit)
                    ActivityIndicatorSwiftUIView(shouldAnimate: self.$customerLiveVM.showSpinner)
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                self.appState.showLiveViewFullscreen = true
                                self.appState.videoURL = self.customerLiveVM.cameraUrl
                            }) {
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    .font(Font.system(.headline))
                                    .foregroundColor(Color(.systemGray))
                                    .padding()
                            }
                        }
                    }
                }
                .aspectRatio(16.0/9.0, contentMode: .fit)
                
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color(.systemGray6))
                        .aspectRatio(16.0/9.0, contentMode: .fit)
                    Text("No live stream currently")
                }
            }
            
            if self.customerLiveVM.dogSitterProfile != nil {
                Group {
                    Text("Today's \(UserType.dogsitter.rawValue)")
                        .font(.title)
                        .padding(.bottom, 10.0)
                    
                    HStack {
                        AsyncImage<Group>(
                            image: self.customerLiveVM.dogSitterImage,
                            placeholder: {
                                Group {
                                    Image("profile-image-placeholder")
                                        .resizable()
                                        .frame(width: 100.0, height: 100.0)
                                }
                            })
                            .padding(.trailing)
                        
                        VStack {
                            self.customerLiveVM.dogSitterProfile.map {
                                $0.display_name.map { Text($0) }
                            }
                            .padding(.bottom)
                            
                            self.customerLiveVM.dogSitterProfile.map {
                                $0.phone_number.map { HiddenText(text: .constant($0)) }
                            }
                        }
                        .padding(.leading)
                    }
                }
                .padding(.top)
            } else {
                Text("No dog sitter booked today")
                    .padding(.top)
            }
            Spacer()
        }
        .onAppear {
            self.customerLiveVM.appState = self.appState
            if let firebaseUser = Auth.auth().currentUser {
                self.customerLiveVM.getAcuityAppointments(user: firebaseUser, optionalNetworkingAPI: nil, completionHandler: nil)
            }
        }
    }
}

struct CustomerLiveView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerLiveView()
    }
}
