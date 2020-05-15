//
//  DogSitterAppTests.swift
//  DogSitterAppTests
//
//  Created by Raymond Yu on 5/1/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import XCTest
@testable import DogSitterApp

class UserModelTests: XCTestCase {

    let LOGIN_URL = "https://playbowtech.com/api/login/"
    let LOGIN_EMAIL = "test1@playbow.com"
    let LOGIN_PASSWORD = "bella1410"
    let ERROR_MESSAGE = "Sorry, unable to complete login"
    let STATUS_CODE_200 = 200
    let STATUS_CODE_404 = 404
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
//    func testUserLoginUsesCorrectCredentials() {
//        // given
//        guard let url = URL(string: LOGIN_URL) else { return }
//        let body: [String: Any] = [
//            "email": LOGIN_EMAIL,
//            "password": LOGIN_PASSWORD
//        ]
//        guard let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: .sortedKeys) else { return }
//        let urlSessionMock = URLSessionMock()
//        let sutUser = User(email: LOGIN_EMAIL, password: LOGIN_PASSWORD)
//        let expectation = XCTestExpectation(description: "Successfully used user credentials")
//        
//        // when
//        sutUser.login(with: url, using: urlSessionMock) { message in
//            print("jsonBody inside test:\n", jsonBody)
//            XCTAssertTrue(jsonBody.elementsEqual(urlSessionMock.lastJsonRequestBody ?? Data()), "JSON credentials were not correctly used by User.login()")
//            expectation.fulfill()
//            print("Message returned by User.login: ", message ?? "")
//        }
//        
//        // then
//        wait(for: [expectation], timeout: 5)
//    }
//    
//    func testUserLoginCallsResume() {
//        // given
//        guard let url = URL(string: LOGIN_URL) else { return }
//        let urlSessionMock = URLSessionMock()
//        let user = User(email: LOGIN_EMAIL, password: LOGIN_PASSWORD)
//        let expectation = XCTestExpectation(description: "Successfully called resume()")
//
//        // when
//        user.login(with: url, using: urlSessionMock) { message in
//            XCTAssertTrue(urlSessionMock.dataTask?.resumeWasCalled ?? false, "Resume was not called")
//            expectation.fulfill()
//        }
//
//        // then
//        wait(for: [expectation], timeout: 5)
//    }
//    
//    func testUserLoginSavesAuthToken() {
//        // given
//        guard let url = URL(string: LOGIN_URL) else { return }
//        let auth_token = "abcd1234"
//        let responseDict = ["auth_token": auth_token]
//        let user = User(email: LOGIN_EMAIL, password: LOGIN_PASSWORD)
//        let urlSessionMock = URLSessionMock(statusCode: STATUS_CODE_200, responseDict: responseDict)
//        let expectation = XCTestExpectation(description: "Successfully saved auth_token upon User.login()")
//
//        // when
//        user.login(with: url, using: urlSessionMock) { message in
//            XCTAssertEqual(auth_token, user.auth_token, "Auth token not retrieved and saved correctly")
//            expectation.fulfill()
//        }
//        
//        // then
//        wait(for: [expectation], timeout: 5)
//    }
//    
//    func testUserLoginHandles404StatusCode() {
//        // given
//        guard let url = URL(string: LOGIN_URL) else { return }
//        let user = User(email: LOGIN_EMAIL, password: LOGIN_PASSWORD)
//        let urlSessionMock = URLSessionMock(statusCode: STATUS_CODE_404, responseDict: nil)
//        let expectation = XCTestExpectation(description: "User.login() handled STATUS_CODE_404")
//        
//        // when
//        user.login(with: url, using: urlSessionMock) { (message) in
//            XCTAssertEqual(self.ERROR_MESSAGE, message)
//            expectation.fulfill()
//        }
//        
//        // then
//        wait(for: [expectation], timeout: 5)
//    }
    

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
