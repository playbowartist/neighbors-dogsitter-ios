//
//  NetworkingAPI.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/6/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation

typealias Success = Bool

protocol NetworkingAPIProtocol {
    
    func postLogin(email: String, password: String, completionHandler: @escaping (String?) -> Void)
    func getCameraUrl(completionHandler: @escaping (URL?) -> Void)
    func startRecording(completionHandler: @escaping (Success?) -> Void)
    func stopRecording(completionHandler: @escaping (Success?) -> Void)
    func getRecordingList(completionHandler: @escaping ([Video]?) -> Void)
    
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
            
            let cameraList = try? JSONDecoder().decode(GetCameraResponse.self, from: data)
            guard let cameraUrlString = cameraList?.results[self.resultsIndex].streams[self.streamsIndex].url,
                let cameraUrl = URL(string: cameraUrlString) else {
                    completionHandler(nil)
                    return
            }
            completionHandler(cameraUrl)
        }
    }
    
    func startRecording(completionHandler: @escaping (Success?) -> Void) {
        
        self.httpService.postReturn204(url: urls.startRecordingUrl, authHeader: angelCamAuthHeader, requestJsonBody: [:]) { (success) in
            completionHandler(success)
        }
    }
    
    func stopRecording(completionHandler: @escaping (Success?) -> Void) {
                
        self.httpService.postReturn204(url: urls.stopRecordingUrl, authHeader: angelCamAuthHeader, requestJsonBody: [:]) { (success) in
            completionHandler(success)
        }
    }
    
    func getRecordingList(completionHandler: @escaping ([Video]?) -> Void) {
        
        self.httpService.getData(url: urls.getRecordingListUrl, authHeader: angelCamAuthHeader) { (data) in
            
            guard let data = data else {
                completionHandler(nil)
                return
            }
            
            var videoList = [Video]()
            let iso8601DateFormatter = ISO8601DateFormatter()
            
            let response = try? JSONDecoder().decode(GetRecordingListResponse.self, from: data)
            
            if let response = response {
                
                let results = response.results
                
                for result in results {
                    
                    let url = URL(string: result.download_url!)!
                    let startDate = iso8601DateFormatter.date(from: result.start!)
                    let stopDate = iso8601DateFormatter.date(from: result.end!)
                    
                    videoList.append(Video(url: url, name: result.name, startDate: startDate, stopDate: stopDate))
                }
                
                completionHandler(videoList)
            }
            
        }
    }
}
