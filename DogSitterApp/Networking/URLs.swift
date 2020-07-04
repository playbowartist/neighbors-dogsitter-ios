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
    
    // Angelcam Urls
    let angelCamBaseUrlString = "https://api.angelcam.com/v1/"
    let getCamerasUrlString = "cameras/"
    let getCamerasUrl = URL(string: "https://api.angelcam.com/v1/cameras/")!
    let startRecordingUrl = URL(string: "https://api.angelcam.com/v1/cameras/94396/recording/start/")!
    let stopRecordingUrl = URL(string: "https://api.angelcam.com/v1/cameras/94396/recording/stop/")!
    let getRecordingListUrl = URL(string: "https://api.angelcam.com/v1/cameras/94396/clips/")!

    
    func createUrl(baseUrlString: String, urlString: String) -> URL? {
        let urlString = baseUrlString + urlString
        return URL(string: urlString)
    }
}
