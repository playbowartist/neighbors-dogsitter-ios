//
//  LoginViewModelTests.swift
//  DogSitterAppTests
//
//  Created by Raymond Yu on 5/7/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import XCTest
@testable import DogSitterApp

class LoginViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGoodLoginReturnsAuthToken() throws {
        // given
        let auth_token = "abc123"
        let responseDict = [
            "data": [
                "auth_token": auth_token
            ]
        ]
        let loginVM = LoginViewModel()
        let session = URLSessionMock(statusCode: 200, responseDict: responseDict)
        let httpService = HttpService(session: session)
        let networkingAPI = NetworkingAPI(httpService: httpService)
        let expectation = XCTestExpectation(description: "Networking task complete")
        
        loginVM.login(networkingAPI: networkingAPI) {
            XCTAssertEqual(loginVM.user.auth_token!, auth_token)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testBadLoginReturnsNil() throws {
        let responseDict: [String: Any]? = nil
        let loginVM = LoginViewModel()
        let session = URLSessionMock(statusCode: 400, responseDict: responseDict)
        let httpService = HttpService(session: session)
        let networkingAPI = NetworkingAPI(httpService: httpService)
        let expectation = XCTestExpectation(description: "Networking task complete")
        
        loginVM.login(networkingAPI: networkingAPI) {
            XCTAssertEqual(loginVM.user.auth_token, nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        
    }
    
    func testLoginSavesAuthTokenInUserObject() {
        let newUser = User(email: "email", password: "pass")
        
    }
}
