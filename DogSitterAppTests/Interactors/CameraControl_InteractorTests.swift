//
//  CameraControl_InteractorTests.swift
//  DogSitterAppTests
//
//  Created by Raymond Yu on 5/18/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import XCTest
@testable import DogSitterApp

class CameraControl_InteractorTests: XCTestCase {

    let networkingHelper = NetworkingTestHelpers()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testStartRecordingWith200StatusCodeClearsUrl() throws {
//        let cameraControlVM = CameraControlViewModel()
//        let sutInteractor = CameraControl_Interactor(cameraControlVM: cameraControlVM)
//
//        let session = URLSessionMock(statusCode: 200, responseDict: networkingHelper.startResponseDict)
//        let httpService = HttpService(session: session)
//        let networkingAPI = NetworkingAPI(httpService: httpService)
//        let expectation = XCTestExpectation(description: "Networking task complete")
//
//        sutInteractor.startRecording(networkingAPI: networkingAPI) {
//            XCTAssertEqual(cameraControlVM.cameraUrl, self.networkingHelper.plantCamHlsUrl)
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5)
//    }
    
    func testStartRecordingWith204StatusCodeForwardsCameraUrlToViewModel() throws {
        let cameraControlVM = CameraControlViewModel()
        let sutInteractor = CameraControl_Interactor(cameraControlVM: cameraControlVM)
        cameraControlVM.cameraUrl = nil
        
        let startRecordingAPI = networkingHelper.createNetworkingAPIMock(statusCode: 204, responseDict: [:])
        let getCameraAPI = networkingHelper.createNetworkingAPIMock(statusCode: 200, responseDict: networkingHelper.startResponseDict)
        let expectation = XCTestExpectation(description: "Networking task complete")
        
        sutInteractor.startRecording(networkingAPI: [startRecordingAPI, getCameraAPI]) {
            XCTAssertEqual(cameraControlVM.cameraUrl, self.networkingHelper.plantCamHlsUrl)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    // TODO: Test that authHeader is passed to NetworkingAPI / HttpService for postReturn204()
    
//    func testStopCameraClearsUrl() throws {
//        let sutCameraControlVM = CameraControlViewModel()
//        sutCameraControlVM.cameraUrl = networkingHelper.plantCamHlsUrl
//        let networkingAPI = networkingHelper.createNetworkingAPIMock(statusCode: 200, responseDict: networkingHelper.stopResponseDict)
//        let expectation = XCTestExpectation(description: "Networking task complete")
//
//        sutCameraControlVM.stopBroadcast(networkingAPI: networkingAPI) {
//            XCTAssertEqual(sutCameraControlVM.cameraUrl, nil)
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5)
//    }

}
