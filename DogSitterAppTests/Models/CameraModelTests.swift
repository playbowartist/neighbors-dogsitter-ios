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
    
    let networkingHelper = NetworkingTestHelpers()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStartReturnsBroadcastUrl() {
        var urlReturned: URL? = nil
        let sutCamera = Camera()
        let networkingAPI = networkingHelper.createNetworkingAPIMock(statusCode: 200, responseDict: networkingHelper.startResponseDict)
        let expectation = XCTestExpectation(description: "Networking task complete")
        
        sutCamera.startBroadcast(networkingAPI: networkingAPI) { url in
            urlReturned = url
            XCTAssertEqual(urlReturned, self.networkingHelper.plantCamHlsUrl)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(urlReturned)
    }
    
    func testStartSavesBroadcastUrlAsProperty() {
        var urlReturned: URL? = nil
        let sutCamera = Camera()
        let networkingAPI = networkingHelper.createNetworkingAPIMock(statusCode: 200, responseDict: networkingHelper.startResponseDict)
        let expectation = XCTestExpectation(description: "Networking task complete")
        
        sutCamera.startBroadcast(networkingAPI: networkingAPI) { url in
            urlReturned = url
            XCTAssertEqual(sutCamera.broadcastUrl, self.networkingHelper.plantCamHlsUrl)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(urlReturned)

    }
    
//    func testStopReturnsSuccessAndClearsBroadcastUrlProperty() {
//        let urlInitial: URL? = networkingHelper.plantCamHlsUrl
//        let sutCamera = Camera()
//        sutCamera.broadcastUrl = urlInitial
//        let networkingAPI = networkingHelper.createNetworkingAPIMock(statusCode: 200, responseDict: networkingHelper.stopResponseDict)
//        let expectation = XCTestExpectation(description: "Networking task complete")
//
//        sutCamera.stopBroadcast(networkingAPI: networkingAPI) { success in
//            guard let success = success else {
//                XCTFail()
//                expectation.fulfill()
//                return
//            }
//            XCTAssertEqual(success, true)
//            XCTAssertEqual(sutCamera.broadcastUrl, nil)
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 5)
//        XCTAssertNil(sutCamera.broadcastUrl)
//    }
}
