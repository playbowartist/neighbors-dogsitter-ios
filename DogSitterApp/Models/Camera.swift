//
//  Camera.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/11/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation

typealias Success = Bool

class Camera {

    var broadcastUrl: URL?
    
    func startBroadcast(networkingAPI: NetworkingAPIProtocol?, completionHandler: @escaping (URL?) -> Void) {
        
        var startBroadcastAPI: NetworkingAPIProtocol {
            if let networkingAPI = networkingAPI {
                return networkingAPI
            } else {
                let session = URLSession(configuration: .default)
                let httpService = HttpService(session: session)
                return NetworkingAPI(httpService: httpService)
            }
        }
        
        startBroadcastAPI.getCameraUrl { (url) in
            guard let url = url else {
                completionHandler(nil)
                return
            }
            
            self.broadcastUrl = url
            completionHandler(url)
        }
    }
    
//    func stopBroadcast(networkingAPI: NetworkingAPIProtocol?, completionHandler: @escaping (Success?) -> Void) {
//        
//        var stopBroadcastAPI: NetworkingAPIProtocol {
//            if let networkingAPI = networkingAPI {
//                return networkingAPI
//            } else {
//                let session = URLSession(configuration: .default)
//                let httpService = HttpService(session: session)
//                return NetworkingAPI(httpService: httpService)
//            }
//        }
//        
//        stopBroadcastAPI.stopBroadcast { success in
//            guard let success = success else {
//                completionHandler(nil)
//                return
//            }
//            
//            self.broadcastUrl = nil
//            completionHandler(success)
//        }
//    }
    
}
