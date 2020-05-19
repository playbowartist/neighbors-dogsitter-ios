//
//  CameraControl_Interactor.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/18/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation

class CameraControl_Interactor {
    
    let cameraControlVM: CameraControlViewModel
    
    init(cameraControlVM: CameraControlViewModel) {
        self.cameraControlVM = cameraControlVM
    }
    
    // TODO: Refactor the following code
    func startRecording(networkingAPI: [NetworkingAPIProtocol]?, completionHandler: (() -> Void)?) {
        
        // Determine whether networkingAPI is passed as a parameter
        var startRecordingAPI: NetworkingAPIProtocol {
            if let networkingAPI = networkingAPI {
                return networkingAPI[0]
            } else {
                let session = URLSession(configuration: .default)
                let httpService = HttpService(session: session)
                return NetworkingAPI(httpService: httpService)
            }
        }
        
        var getCameraAPI: NetworkingAPIProtocol {
            if let networkingAPI = networkingAPI {
                return networkingAPI[1]
            } else {
                let session = URLSession(configuration: .default)
                let httpService = HttpService(session: session)
                return NetworkingAPI(httpService: httpService)
            }
        }
        
        // Check startRecording was successful before retrieving cameraUrl
        startRecordingAPI.startRecording { (success) in
            guard success == true else {
                self.cameraControlVM.cameraUrl = nil
                completionHandler?()
                return
            }
            
            getCameraAPI.getCameraUrl { (url) in
                guard let url = url else {
                    self.cameraControlVM.cameraUrl = nil
                    completionHandler?()
                    return
                }

                self.cameraControlVM.cameraUrl = url
                completionHandler?()
            }
        }
    }
    
//    func stopBroadcast(networkingAPI: NetworkingAPIProtocol?, completionHandler: (() -> Void)?) {
//
//        self.camera.stopBroadcast(networkingAPI: networkingAPI) { success in
//            guard let success = success else {
//                self.cameraUrl = nil
//                completionHandler?()
//                return
//            }
//            self.cameraUrl = nil
//            print("Camera stopped successfully: ", success)
//            completionHandler?()
//        }
//    }
}
