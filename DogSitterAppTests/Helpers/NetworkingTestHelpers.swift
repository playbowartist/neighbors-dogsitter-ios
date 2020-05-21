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
    
    let plantCamHlsUrl = URL(string: "https://m2-na3.angelcam.com/cameras/94396/streams/hls/playlist.m3u8?token=eyJjYW1lcmFfaWQiOiI5NDM5NiIsInRpbWUiOjE1ODg4MDQ2ODQ1Nzg5MTUsInRpbWVvdXQiOjM2MDB9%2Ea12b8a3068bfa7baff937c8753355674137b95203e4d8254a827580f90b0ab7d")!
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
                        "url": "https://m2-na3.angelcam.com/cameras/94396/streams/hls/playlist.m3u8?token=eyJjYW1lcmFfaWQiOiI5NDM5NiIsInRpbWUiOjE1ODg4MDQ2ODQ1Nzg5MTUsInRpbWVvdXQiOjM2MDB9%2Ea12b8a3068bfa7baff937c8753355674137b95203e4d8254a827580f90b0ab7d"
                    ]
                ]
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
