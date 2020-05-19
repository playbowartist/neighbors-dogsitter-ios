//
//  TestDoubles.swift
//  DogSitterAppTests
//
//  Created by Raymond Yu on 5/2/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation
@testable import DogSitterApp

class URLSessionMock: URLSessionProtocol {
    var lastJsonRequestBody: Data?
    var lastAuthHeader: String?
    var dataTask: DataTaskMock?
    var responseDict: [String: Any]?
    var statusCode: Int?
    var responseHeaders: URLResponse?
    var responseData: Data?
    
    
    init() { }
    
    init(statusCode: Int?, responseDict: [String: Any]?) {
        self.statusCode = statusCode
        self.responseDict = responseDict
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.lastJsonRequestBody = request.httpBody
        self.lastAuthHeader = request.allHTTPHeaderFields?["Authorization"]
        
        // Prepare http response (data, response, error) if provided
        if let statusCode = self.statusCode,
            let url = request.url {
            self.responseHeaders = HTTPURLResponse(url: url,
                                                   statusCode: statusCode,
                                                   httpVersion: nil,
                                                   headerFields: nil)
        }
        if let responseDict = self.responseDict {
            self.responseData = try? JSONSerialization.data(withJSONObject: responseDict, options: .sortedKeys)
        }
        let dataTaskMock = DataTaskMock(responseHeaders: self.responseHeaders,
                                        responseData: self.responseData,
                                        completionHandler: completionHandler)
        self.dataTask = dataTaskMock
        return dataTaskMock
    }
}
