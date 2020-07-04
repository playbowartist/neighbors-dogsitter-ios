//
//  Webservice.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/5/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
        -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }

class HttpService {
    
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func getData(url: URL, authHeader: String?, completionHandler: @escaping (Data?) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        if let authHeader = authHeader {
            urlRequest.addValue(authHeader, forHTTPHeaderField: "Authorization")
        }
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            let STATUS_CODE_200 = 200
            
            // Check that data is available
            // Check that HttpResponse's status code = 200
            guard let data = data,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == STATUS_CODE_200 else {
                    completionHandler(nil)
                    return
            }
            completionHandler(data)
        }.resume()
    }
    
    func postJsonData(url: URL, requestJsonBody: [String: Any], completionHandler: @escaping (Data?) -> Void) {
        guard let requestBody = try?
            JSONSerialization.data(withJSONObject: requestJsonBody, options: .sortedKeys) else {
                return
        }
        let contentType = "application/json"
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = requestBody
        urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            let STATUS_CODE_200 = 200
            
            // Check that data is available
            // Check that HttpResponse's status code = 200
            guard let data = data,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == STATUS_CODE_200 else {
                    print("httpResponse.statusCode: ", (response as! HTTPURLResponse).statusCode)
                    completionHandler(nil)
                    return
            }
            completionHandler(data)
        }.resume()
    }
    
    func postReturn204(url: URL, authHeader: String?, requestJsonBody: [String: Any], completionHandler: @escaping (Success) -> Void) {
        guard let requestBody = try?
            JSONSerialization.data(withJSONObject: requestJsonBody, options: .sortedKeys) else {
                return
        }
        let contentType = "application/json"
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = requestBody
        urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
        if let authHeader = authHeader {
            urlRequest.addValue(authHeader, forHTTPHeaderField: "Authorization")
        }
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            let STATUS_CODE_204 = 204
            
            // Check that HttpResponse's status code = 204
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == STATUS_CODE_204 else {
                    completionHandler(false)
                    return
            }
            completionHandler(true)
        }.resume()
    }
}
