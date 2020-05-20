//
//  CameraControlView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/3/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

struct CameraControlView: View {
    
    @ObservedObject var cameraControlVM = CameraControlViewModel()
    lazy var cameraControl_Interactor = CameraControl_Interactor(cameraControlVM: cameraControlVM)
    
    func mutableCameraControl_Interactor() -> CameraControl_Interactor {
        var mutableSelf = self
        return mutableSelf.cameraControl_Interactor
    }
    
    var body: some View {
        
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
                // TODO: Call interactor's stopRecording()
                self.cameraControlVM.cameraUrl = nil
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

