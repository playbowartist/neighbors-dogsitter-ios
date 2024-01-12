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
    func getCameraUrl(authHeader: String, completionHandler: @escaping (URL?) -> Void)
//    func startRecording(completionHandler: @escaping (Success?) -> Void)
//    func stopRecording(completionHandler: @escaping (Success?) -> Void)
//    func getRecordingList(completionHandler: @escaping ([Video]?) -> Void)
    func getAcuityAppointments(minDate: String, maxDate: String, email: String?, phoneNumber: String?, calendarID: Int?, completionHandler: @escaping ([Appointment]?) -> Void)
    func getAcuityCalendars(completionHandler: @escaping ([AcuityCalendar]?) -> Void)
    func getRecordedClipUrl(clip_id: String, completionHandler: @escaping (URL?) -> Void)
}

class NetworkingAPIFactory {
    
    static func networkingAPI() -> NetworkingAPI {
        let session = URLSession(configuration: .default)
        let httpService = HttpService(session: session)
        let networkingAPI = NetworkingAPI(httpService: httpService)
        return networkingAPI
    }
}

class NetworkingAPI: NetworkingAPIProtocol {
    
    let urls = URLs()
    let acuityAuthHeader = "Basic MjAxNzg1MDg6ZGQxNWEyNmZkYTc2MTJlOGNmMGMyN2RlNTU3NzgwYjg"
    let angelCamBaseAuthHeader = "PersonalAccessToken "
    let angelCamAuthHeader = "PersonalAccessToken afec708ac67fbccaa1a9b1c3ec3c31a34d740879"
    let resultsIndex = 0
    let streamsIndex = 3
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
    
    func getCameraUrl(authHeader: String, completionHandler: @escaping (URL?) -> Void) {
        self.httpService.getData(url: urls.getCamerasUrl, authHeader: authHeader) { (data) in
            
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
    
//    func startRecording(completionHandler: @escaping (Success?) -> Void) {
//        print("inside startRecording() networkingAPI")
//        self.httpService.postReturn204(url: urls.startRecordingUrl, authHeader: angelCamAuthHeader, requestJsonBody: [:]) { (success) in
//            completionHandler(success)
//        }
//    }
    
//    func stopRecording(completionHandler: @escaping (Success?) -> Void) {
//
//        self.httpService.postReturn204(url: urls.stopRecordingUrl, authHeader: angelCamAuthHeader, requestJsonBody: [:]) { (success) in
//            completionHandler(success)
//        }
//    }
    
//    func getRecordingList(completionHandler: @escaping ([Video]?) -> Void) {
//
//        self.httpService.getData(url: urls.getRecordingListUrl, authHeader: angelCamAuthHeader) { (data) in
//
//            guard let data = data else {
//                completionHandler(nil)
//                return
//            }
//
//            var videoList = [Video]()
//            let iso8601DateFormatter = ISO8601DateFormatter()
//
//            let response = try? JSONDecoder().decode(GetRecordingListResponse.self, from: data)
//
//            if let response = response {
//                let results = response.results
//
//                for result in results {
//
//                    let url = URL(string: result.download_url!)!
//                    let startDate = iso8601DateFormatter.date(from: result.start!)
//                    let stopDate = iso8601DateFormatter.date(from: result.end!)
//
////                    videoList.append(Video(url: url, name: result.name, startDate: startDate, stopDate: stopDate))
//                }
//
//                completionHandler(videoList)
//            }
//
//        }
//    }
    
    func getAcuityAppointments(minDate: String, maxDate: String, email: String?, phoneNumber: String?, calendarID: Int?, completionHandler: @escaping ([Appointment]?) -> Void) {
                
        var queryParameters: [String: String] = [
            "minDate": minDate,
            "maxDate": maxDate,
        ]
        
        if let email = email {
            queryParameters["email"] = email
        }
        
        if let phoneNumber = phoneNumber {
            queryParameters["phone"] = phoneNumber
        }
        
        if let calendarID = calendarID {
            queryParameters["calendarID"] = String(calendarID)
        }
        
        guard var urlComponents = URLComponents(url: urls.getAcuityAppointments, resolvingAgainstBaseURL: true)
            else { return }
        urlComponents.setQueryItems(with: queryParameters)
        guard let url = urlComponents.url else { return }
        
        self.httpService.getData(url: url, authHeader: acuityAuthHeader) { (data) in
            
            guard let data = data else {
                completionHandler(nil)
                return
            }
            
            guard let appointmentList = try? JSONDecoder().decode([Appointment].self, from: data) else {
                completionHandler(nil)
                return
            }
            
            completionHandler(appointmentList)
        }
    }
    
    func getAcuityClients(phoneNumber: String, completionHandler: @escaping ([AcuityClient]?) -> Void) {
                
        let queryParameters: [String: String] = [
            "phone": phoneNumber,
        ]
        
        guard var urlComponents = URLComponents(url: urls.getClients, resolvingAgainstBaseURL: true)
            else { return }
        urlComponents.setQueryItems(with: queryParameters)
        guard let url = urlComponents.url else { return }
        
        self.httpService.getData(url: url, authHeader: acuityAuthHeader) { (data) in
            
            guard let data = data else {
                completionHandler(nil)
                return
            }
            
            guard let clientList = try? JSONDecoder().decode([AcuityClient].self, from: data) else {
                completionHandler(nil)
                return
            }
            print("clientList:\n", clientList)
            completionHandler(clientList)
        }
    }
    
    func getAcuityCalendars(completionHandler: @escaping ([AcuityCalendar]?) -> Void) {
        
        guard let urlComponents = URLComponents(url: urls.getCalendars, resolvingAgainstBaseURL: true)
            else { return }
        guard let url = urlComponents.url else { return }
        
        self.httpService.getData(url: url, authHeader: acuityAuthHeader) { (data) in
            
            guard let data = data else {
                completionHandler(nil)
                return
            }
            
            guard let calendarList = try? JSONDecoder().decode([AcuityCalendar].self, from: data) else {
                completionHandler(nil)
                return
            }
            completionHandler(calendarList)
        }
    }
    
    func getRecordedClipUrl(clip_id: String, completionHandler: @escaping (URL?) -> Void) {
        self.httpService.getData(url: urls.getRecordedClipUrl(clip_id: clip_id), authHeader: angelCamAuthHeader) { (data) in
            guard let data = data else {
                completionHandler(nil)
                return
            }

            let response = try? JSONDecoder().decode(GetRecordedClipResponse.self, from: data)
            if let response = response,
               let download_url_string = response.download_url,
               let download_url = URL(string: download_url_string) {
                completionHandler(download_url)
            }
            completionHandler(nil)
        }
    }
    
    
}
