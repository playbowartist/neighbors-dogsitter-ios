//
//  NetworkingAPI.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/6/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation

struct AngelcamCameraList: Decodable {
    var results: [Results]
}

struct Results: Decodable {
    var streams: [Streams]
}

struct Streams: Decodable {
    var format: String?
    var url: String?
}

struct LoginResponse: Decodable {
    var data: AuthToken
}

struct AuthToken: Decodable {
    var auth_token: String?
}

protocol NetworkingAPIProtocol {
    
    func postLogin(email: String, password: String, completionHandler: @escaping (String?) -> Void)
    func getCameraUrl(completionHandler: @escaping (URL?) -> Void)
    func stopBroadcast(completionHandler: @escaping (Success?) -> Void)
    
}


class NetworkingAPI: NetworkingAPIProtocol {
    
    // These constants can be moved to a separate file, and broken up as needed
    let getCamerasUrl = URL(string: "https://api.angelcam.com/v1/cameras/")!
    let angelCamAuthHeader = "PersonalAccessToken afec708ac67fbccaa1a9b1c3ec3c31a34d740879"
    let resultsIndex = 0
    let streamsIndex = 2
    
    // Login constants
    let loginUrl = URL(string: "https://playbowtech.com/api/login/")!
    
    let httpService: HttpService
    
    init(httpService: HttpService) {
        self.httpService = httpService
    }
    
    func postLogin(email: String, password: String, completionHandler: @escaping (String?) -> Void) {
        
        let requestJsonBody = [
            "email": email,
            "password": password
        ]
        
        self.httpService.postJsonData(url: loginUrl, requestJsonBody: requestJsonBody) { (data) in
            
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
        
        self.httpService.getData(url: getCamerasUrl, authHeader: angelCamAuthHeader) { (data) in
            
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
        
        // TODO: research stopBroadcast Angelcam API
        
        self.httpService.getData(url: getCamerasUrl, authHeader: angelCamAuthHeader) { (data) in
            
            guard let data = data else {
                completionHandler(nil)
                return
            }
//            let cameraList = try? JSONDecoder().decode(AngelcamCameraList.self, from: data)
            
            completionHandler(true)
        }
    }
}
