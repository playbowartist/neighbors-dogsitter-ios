//
//  CameraModelTests.swift
//  DogSitterAppTests
//
//  Created by Raymond Yu on 5/11/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import XCTest
@testable import DogSitterApp

class CameraModelTests: XCTestCase {
    
    let plantCamHlsUrl = URL(string: "https://m2-na3.angelcam.com/cameras/94396/streams/hls/playlist.m3u8?token=eyJjYW1lcmFfaWQiOiI5NDM5NiIsInRpbWUiOjE1ODg4MDQ2ODQ1Nzg5MTUsInRpbWVvdXQiOjM2MDB9%2Ea12b8a3068bfa7baff937c8753355674137b95203e4d8254a827580f90b0ab7d")!
    let responseDict: [String: Any] = [
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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStartReturnsBroadcastUrl() {
        var urlReturned: URL? = nil
        let sutCamera = Camera()
        let session = URLSessionMock(statusCode: 200, responseDict: responseDict)
        let httpService = HttpService(session: session)
        let networkingAPI = NetworkingAPI(httpService: httpService)
        let expectation = XCTestExpectation(description: "Networking task complete")
        
        sutCamera.startBroadcast(networkingAPI: networkingAPI) { url in
            urlReturned = url
            XCTAssertEqual(urlReturned, self.plantCamHlsUrl)
            expectation.fulfill()
        }
        
        XCTAssertNotNil(urlReturned)
        wait(for: [expectation], timeout: 5)
    }
    
    func testStartSavesBroadcastUrlAsProperty() {
        var urlReturned: URL? = nil
        let sutCamera = Camera()
        let session = URLSessionMock(statusCode: 200, responseDict: responseDict)
        let httpService = HttpService(session: session)
        let networkingAPI = NetworkingAPI(httpService: httpService)
        let expectation = XCTestExpectation(description: "Networking task complete")
        
        sutCamera.startBroadcast(networkingAPI: networkingAPI) { url in
            urlReturned = url
            XCTAssertEqual(sutCamera.broadcastUrl, self.plantCamHlsUrl)
            expectation.fulfill()
        }
        
        XCTAssertNotNil(urlReturned)
        wait(for: [expectation], timeout: 5)
    }

    func testStopReturnsNil() {
        
    }
    
    func testStopClearsBroadcastUrlProperty() {
    
    }
}
