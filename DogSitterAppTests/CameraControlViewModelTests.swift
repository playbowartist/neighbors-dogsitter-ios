//
//  CameraControlViewModelTests.swift
//  DogSitterAppTests
//
//  Created by Raymond Yu on 5/11/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import XCTest
@testable import DogSitterApp

class CameraControlViewModelTests: XCTestCase {

    let networkingHelper = NetworkingTestHelpers()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStartSavesCameraUrl() throws {
        let sutCameraControlVM = CameraControlViewModel(camera: Camera())
        sutCameraControlVM.cameraUrl = nil
        let networkingAPI = networkingHelper.createNetworkingAPIMock(statusCode: 200, responseDict: networkingHelper.startResponseDict)
        let expectation = XCTestExpectation(description: "Networking task complete")
        
        sutCameraControlVM.startBroadcast(networkingAPI: networkingAPI) {
            XCTAssertEqual(sutCameraControlVM.cameraUrl, self.networkingHelper.plantCamHlsUrl)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testStopCameraClearsUrl() throws {
        let sutCameraControlVM = CameraControlViewModel(camera: Camera())
        sutCameraControlVM.cameraUrl = networkingHelper.plantCamHlsUrl
        let networkingAPI = networkingHelper.createNetworkingAPIMock(statusCode: 200, responseDict: networkingHelper.stopResponseDict)
        let expectation = XCTestExpectation(description: "Networking task complete")
        
        sutCameraControlVM.stopBroadcast(networkingAPI: networkingAPI) {
            XCTAssertEqual(sutCameraControlVM.cameraUrl, nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

}
