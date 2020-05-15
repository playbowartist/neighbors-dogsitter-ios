//
//  NetworkingTests.swift
//  DogSitterAppTests
//
//  Created by Raymond Yu on 5/4/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import XCTest
@testable import DogSitterApp

class HttpServiceTests: XCTestCase {
    
    let GET_URL_NO_AUTH_NO_PARAMETERS = "https://api.angelcam.com/v1/cameras/"
    let GET_URL_YES_AUTH_NO_PARAMETERS = ""
    let LOGIN_URL = "https://playbowtech.com/api/login/"
    let LOGIN_EMAIL = "test1@playbow.com"
    let LOGIN_PASSWORD = "bella1410"
    
    let STATUS_CODE_200 = 200

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetDataNoParametersNoAuthReturnsCorrectRawData() throws {
        // given
        guard let url = URL(string: GET_URL_NO_AUTH_NO_PARAMETERS) else { return }
        let responseDict: [String: Any] = [
            "testData1": "An awesome piece of data",
            "testData2": 1234,
            "testData3": [11, 22, 33]
        ]
        let rawDataResponse = try? JSONSerialization.data(withJSONObject: responseDict, options: .sortedKeys)
        let httpService = HttpService(session: URLSessionMock(statusCode: STATUS_CODE_200, responseDict: responseDict))
        let expectation = XCTestExpectation(description: "Finished networking task")
        
        // when
        httpService.getData(url: url, authHeader: nil) { (data) in
            guard let data = data else {
                print("Sorry, could not get data from networking")
                XCTFail()
                expectation.fulfill()
                return
            }
            
            // then
            XCTAssertTrue(data.elementsEqual(rawDataResponse ?? Data()))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetDataNoParametersAngelcamAuthCorrectlyPassesAuthHeader() throws {
        // given
        guard let url = URL(string: GET_URL_NO_AUTH_NO_PARAMETERS) else { return }
        let authHeader = "PersonalAccessToken afec708ac67fbccaa1a9b1c3ec3c31a34d740879"
        let responseDict: [String: Any] = [
            "testData1": "An awesome piece of data",
            "testData2": 1234,
            "testData3": [11, 22, 33]
        ]
        let rawDataResponse = try? JSONSerialization.data(withJSONObject: responseDict, options: .sortedKeys)
        let httpService = HttpService(session: URLSessionMock(statusCode: STATUS_CODE_200, responseDict: responseDict))
        let expectation = XCTestExpectation(description: "Finished networking task")
        
        // when
        httpService.getData(url: url, authHeader: authHeader) { (data) in
            guard data != nil else {
                print("Sorry, could not get data from networking")
                XCTFail()
                expectation.fulfill()
                return
            }
            
            // then
            XCTAssertEqual((httpService.session as! URLSessionMock).lastAuthHeader, authHeader)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testPostDataWithJsonParametersNoAuthReturnsCorrectRawData() throws {
        // given
        guard let url = URL(string: LOGIN_URL) else { return }
        let requestJsonBody: [String: Any] = [
            "email": LOGIN_EMAIL,
            "password": LOGIN_PASSWORD
        ]
        let responseDict: [String: Any] = [
            "testData1": "An awesome piece of data",
            "testData2": 1234,
            "testData3": [11, 22, 33]
        ]
        let rawDataResponse = try? JSONSerialization.data(withJSONObject: responseDict, options: .sortedKeys)
        let httpService = HttpService(session: URLSessionMock(statusCode: STATUS_CODE_200, responseDict: responseDict))
        let expectation = XCTestExpectation(description: "Finished networking task")
        
        // when
        httpService.postJsonData(url: url, requestJsonBody: requestJsonBody) { (data) in
            guard let data = data else {
                XCTFail()
                expectation.fulfill()
                return
            }
            
            // then
            XCTAssertTrue(data.elementsEqual(rawDataResponse ?? Data()))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
