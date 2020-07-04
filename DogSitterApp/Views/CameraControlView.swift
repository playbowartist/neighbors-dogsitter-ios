//
//  CameraControlView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/3/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

struct CameraControlView: View {
    
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var cameraControlVM = CameraControlViewModel()
    lazy var cameraControl_Interactor = CameraControl_Interactor(cameraControlVM: cameraControlVM)
    let authAPI = AuthenticationAPI()
    
    func mutableCameraControl_Interactor() -> CameraControl_Interactor {
        var mutableSelf = self
        return mutableSelf.cameraControl_Interactor
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                            
                if self.cameraControlVM.cameraUrl != nil {
                    VideoPlayerSwiftUIView(cameraUrl: self.cameraControlVM.cameraUrl)
                }
                
                Spacer()
                Button("Start Camera") {
                    self.mutableCameraControl_Interactor()
                        .startRecording(networkingAPI: nil, completionHandler: nil)
                }.padding()
                Button("Stop Camera") {
                    self.mutableCameraControl_Interactor()
                        .stopRecording(networkingAPI: nil, completionHandler: nil)
                }.padding()
                Button("Add user info to database") {
                    self.mutableCameraControl_Interactor()
                        .addUserInfo()
                }.padding()
                Button("Send notification") {
                    self.mutableCameraControl_Interactor()
                        .sendNotification()
                }.padding()
            }
            .navigationBarTitle("Camera Controls", displayMode: .inline)
            .navigationBarItems(trailing: Button("Logout") {

                let logoutError = self.authAPI.logout()
                if logoutError == nil {
                    withAnimation(.linear(duration: 1.0)) {
                        self.userSettings.isLoggedIn = false
                    }
                } else {
                    // Display popup indicating logout unsuccessful
                }
            })
        }
    }
}

struct CameraControlView_Previews: PreviewProvider {
    static var previews: some View {
        CameraControlView()
    }
}

