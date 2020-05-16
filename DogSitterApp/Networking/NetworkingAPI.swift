//
//  NetworkingAPI.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/6/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation

protocol NetworkingAPIProtocol {
    
    func postLogin(email: String, password: String, completionHandler: @escaping (String?) -> Void)
    func getCameraUrl(completionHandler: @escaping (URL?) -> Void)
    func stopBroadcast(completionHandler: @escaping (Success?) -> Void)
    
}

class NetworkingAPI: NetworkingAPIProtocol {
    
    let urls = URLs()
    let angelCamAuthHeader = "PersonalAccessToken afec708ac67fbccaa1a9b1c3ec3c31a34d740879"
    let resultsIndex = 0
    let streamsIndex = 2
    let httpService: HttpService
    
    init(httpService: HttpService) {
        self.httpService = httpService
    }
    
    func postLogin(email: String, password: String, completionHandler: @escaping (String?) -> Void) {
        
        let requestJsonBody = [
            "email": email,
            "password": password
        ]
        
        self.httpService.postJsonData(url: urls.loginUrl, requestJsonBody: requestJsonBody) { (data) in
            
            guard let data = data else {
                completionHandler(nil)
                return
            }
            let loginData = try? JSONDecoder().decode(LoginResponse.self, from: data)
            
            guard let auth_token = loginData?.data.auth_token else {
                completionHandler(nil)
                return
            }
            completionHandler(auth_token)
        }
    }
    
    func getCameraUrl(completionHandler: @escaping (URL?) -> Void) {
        
        self.httpService.getData(url: urls.getCamerasUrl, authHeader: angelCamAuthHeader) { (data) in
            
            guard let data = data else {
                completionHandler(nil)
                return
            }
            let cameraList = try? JSONDecoder().decode(AngelcamCameraList.self, from: data)
            
            guard let cameraUrlString = cameraList?.results[self.resultsIndex].streams[self.streamsIndex].url,
                let cameraUrl = URL(string: cameraUrlString) else {
                    completionHandler(nil)
                    return
            }
            completionHandler(cameraUrl)
        }
    }
    
    func stopBroadcast(completionHandler: @escaping (Success?) -> Void) {
                
        self.httpService.getData(url: urls.getCamerasUrl, authHeader: angelCamAuthHeader) { (data) in
            
            guard let data = data else {
                completionHandler(nil)
                return
            }
            completionHandler(true)
        }
    }
}
