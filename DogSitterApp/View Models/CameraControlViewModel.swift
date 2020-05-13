//
//  CameraControlViewModel.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/11/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation

class CameraControlViewModel {
    
    var camera: Camera
    var cameraUrl: URL?
    
    init(camera: Camera) {
        self.camera = camera
    }
    
    func startBroadcast(networkingAPI: NetworkingAPIProtocol?, completionHandler: (() -> Void)?) {
        
        self.camera.startBroadcast(networkingAPI: networkingAPI) { url in
            guard let url = url else {
                self.cameraUrl = nil
                completionHandler?()
                return
            }
            self.cameraUrl = url
            completionHandler?()
        }
    }
}
