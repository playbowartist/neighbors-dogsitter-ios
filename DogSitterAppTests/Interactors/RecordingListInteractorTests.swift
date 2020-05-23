//
//  RecordingListInteractorTests.swift
//  DogSitterAppTests
//
//  Created by Raymond Yu on 5/22/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import XCTest
@testable import DogSitterApp

class RecordingListInteractorTests: XCTestCase {
    
    let networkingHelper = NetworkingTestHelpers()
    
    func testGetRecordingListForwardsVideoListToViewModel() throws {
        let recordingListVM = RecordingListViewModel()
        let sutInteractor = RecordingListInteractor(recordingListVM: recordingListVM)
        
        let recordingListAPI = networkingHelper.createNetworkingAPIMock(statusCode: 200, responseDict: networkingHelper.getRecordingListResponseDict)
        let expectation = XCTestExpectation(description: "Networking task complete")
        
        sutInteractor.getRecordingList(networkingAPI: recordingListAPI) {
            
            XCTAssertEqual(recordingListVM.videoList, self.networkingHelper.videoList)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
}
