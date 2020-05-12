//
//  Camera.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/11/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation

class Camera {

    var broadcastUrl: URL?
    
    func startBroadcast(networkingAPI: NetworkingAPI, completionHandler: @escaping (URL?) -> Void) {
        
        networkingAPI.getCameraUrl { (url) in
            guard let url = url else {
                completionHandler(nil)
                return
            }
            
            self.broadcastUrl = url
            completionHandler(url)
        }
        
//        let session = URLSession(configuration: .default)
//        let httpService = HttpService(session: session)
//        let networkingAPI = NetworkingAPI(httpService: httpService)
//
        
    }
    
}
