//
//  NetworkingTestHelpers.swift
//  DogSitterAppTests
//
//  Created by Raymond Yu on 5/12/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation
@testable import DogSitterApp

class NetworkingTestHelpers {
    
    let iso8601DateFormatter = ISO8601DateFormatter()
    let plantCamHlsUrl = URL(string: "https://plant-cam-url.com")!
    let firstRecordedVideoUrl = URL(string: "https://first-url.com")!
    let secondRecordedVideoUrl = URL(string: "https://second-url.com")!
    lazy var videoUrlList = [firstRecordedVideoUrl, secondRecordedVideoUrl]
    
    lazy var firstVideo = Video(url: firstRecordedVideoUrl, name: "5 Minute Test May 20, 2020", startDate: iso8601DateFormatter.date(from: "2020-05-20T15:00:00Z"), stopDate: iso8601DateFormatter.date(from: "2020-05-20T15:05:00Z"))
    lazy var secondVideo = Video(url: secondRecordedVideoUrl, name: "Test", startDate: iso8601DateFormatter.date(from: "2020-05-18T22:31:02Z"), stopDate: iso8601DateFormatter.date(from: "2020-05-18T22:36:02Z"))
    lazy var videoList = [firstVideo, secondVideo]
    
    let getCamerasResponseDict: [String: Any] = [
        "results": [
            [
                "streams": [
                    [
                        "format": "mjpeg",
                        "url": "https:xxx"
                    ],
                    [
                        "format": "mp4",
                        "url": "https:xxx"
                    ],
                    [
                        "format": "hls",
                        "url": "https://plant-cam-url.com"
                    ]
                ]
            ]
        ]
    ]
    
    let getRecordingListResponseDict: [String: Any] = [
        "count": 2,
        "results": [
            [
                "id": "a328e63e-7b4f-40fe-ac11-9e725bb9c751",
                "status": "READY",
                "sharing_token": "7a741874-dba9-45b8-ab27-724167bac0c7",
                "created_at": "2020-05-21T05:44:34Z",
                "download_url": "https://first-url.com",
                "snapshots": [],
                "name": "5 Minute Test May 20, 2020",
                "start": "2020-05-20T15:00:00Z",
                "end": "2020-05-20T15:05:00Z"
            ],
            [
                "id": "cefc1a88-3634-4c97-9aea-fc5fdf24b9b3",
                "status": "READY",
                "sharing_token": "d2cd47e0-cff5-4d16-bb97-fdf3cbf312d3",
                "created_at": "2020-05-18T22:36:02Z",
                "download_url": "https://second-url.com",
                "snapshots": [],
                "name": "Test",
                "start": "2020-05-18T22:31:02Z",
                "end": "2020-05-18T22:36:02Z"
            ]
        ]
    ]
    
    let empty204ResponseDict: [String: Any] = [:]
    
    func createNetworkingAPIMock(statusCode: Int, responseDict: [String: Any]) -> NetworkingAPIProtocol {
        let session = URLSessionMock(statusCode: statusCode, responseDict: responseDict)
        let httpService = HttpService(session: session)
        return NetworkingAPI(httpService: httpService)
    }
    
}
