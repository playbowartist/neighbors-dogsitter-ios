//
//  URLs.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/16/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation


struct URLs {
    // App Server Urls
    let serverBaseUrlString = "https://playbowtech.com/api/"
    let loginUrlString = "login/"
    let loginUrl = URL(string: "https://playbowtech.com/api/login/")!
    
    // Acuity Urls
    let getAcuityAppointments = URL(string: "https://acuityscheduling.com/api/v1/appointments")!
    let getClients = URL(string: "https://acuityscheduling.com/api/v1/clients")!
    let getCalendars = URL(string: "https://acuityscheduling.com/api/v1/calendars")!
    
    // Angelcam Urls
    let angelCamBaseUrlString = "https://api.angelcam.com/v1/"
    let getCamerasUrlString = "cameras/"
    let getCamerasUrl = URL(string: "https://api.angelcam.com/v1/cameras/")!
    let startRecordingUrl = URL(string: "https://api.angelcam.com/v1/cameras/98280/recording/start/")!
    let stopRecordingUrl = URL(string: "https://api.angelcam.com/v1/cameras/98280/recording/stop/")!
    let getRecordingListUrl = URL(string: "https://api.angelcam.com/v1/cameras/98280/clips/")!
    
    func createUrl(baseUrlString: String, urlString: String) -> URL? {
        let urlString = baseUrlString + urlString
        return URL(string: urlString)
    }
    
    func getRecordedClipUrl(clip_id: String) -> URL {
        let baseUrlString = "https://api.angelcam.com/v1/cameras/98280/clips/"
        let completeUrlString = baseUrlString + clip_id + "/"
        return URL(string: completeUrlString)!
    }
}


extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
