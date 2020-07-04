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
            // completionHandler must be inside DispatchQueue
            // otherwise, it will be executed before cameraUrl assignment
            guard success == true else {
                DispatchQueue.main.async {
                    self.cameraControlVM.cameraUrl = nil
                    completionHandler?()
                }
                return
            }
            
            getCameraAPI.getCameraUrl { (url) in
                guard let url = url else {
                    DispatchQueue.main.async {
                        self.cameraControlVM.cameraUrl = nil
                        completionHandler?()
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.cameraControlVM.cameraUrl = url
                    completionHandler?()
                }
            }
        }
    }
    
    func stopRecording(networkingAPI: NetworkingAPIProtocol?, completionHandler: (() -> Void)?) {
        
        // Determine whether networkingAPI is passed as a parameter
        var stopRecordingAPI: NetworkingAPIProtocol {
            if let networkingAPI = networkingAPI {
                return networkingAPI
            } else {
                let session = URLSession(configuration: .default)
                let httpService = HttpService(session: session)
                return NetworkingAPI(httpService: httpService)
            }
        }
        
        // Set cameraUrl to nil whether successful or not
        stopRecordingAPI.stopRecording { (success) in
            
            DispatchQueue.main.async {
                self.cameraControlVM.cameraUrl = nil
                completionHandler?()
            }
        }
    }
}
