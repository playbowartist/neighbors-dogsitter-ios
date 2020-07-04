//
//  NetworkingAPITests.swift
//  DogSitterAppTests
//
//  Created by Raymond Yu on 5/6/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import XCTest
@testable import DogSitterApp

class NetworkingAPITests: XCTestCase {
    
    let networkingTestHelper = NetworkingTestHelpers()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetCameraUrlFromAngelcam() throws {

        let session = URLSessionMock(statusCode: 200, responseDict: networkingTestHelper.getCamerasResponseDict)
        let httpService = HttpService(session: session)
        let angelcamAPI = NetworkingAPI(httpService: httpService)
        let expectation = XCTestExpectation(description: "Networking task complete")
        angelcamAPI.getCameraUrl { (url) in
            guard let url = url else {
                XCTFail()
                expectation.fulfill()
                return
            }
            XCTAssertEqual(url, self.networkingTestHelper.plantCamHlsUrl)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    
    
}
