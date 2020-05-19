//
//  DataTaskMock.swift
//  DogSitterAppTests
//
//  Created by Raymond Yu on 5/18/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation

class DataTaskMock: URLSessionDataTask {
    var resumeWasCalled: Bool
    var responseHeaders: URLResponse?
    var responseData: Data?
    var completionHandler: (Data?, URLResponse?, Error?) -> Void
    
    init(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.resumeWasCalled = false
        self.completionHandler = completionHandler
    }
    init(responseHeaders: URLResponse?,
         responseData: Data?,
         completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.responseHeaders = responseHeaders
        self.responseData = responseData
        self.resumeWasCalled = false
        self.completionHandler = completionHandler
    }
    override func resume() {
        self.resumeWasCalled = true
        completionHandler(responseData, responseHeaders, nil)
    }
}
