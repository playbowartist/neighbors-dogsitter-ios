//
//  User.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 5/1/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
        -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }


class User {
    
    var email: String
    var password: String
    var auth_token: String?
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func login(with url: URL, using session: URLSessionProtocol, completionHandler: @escaping (String?) -> Void) {
        
        let requestBody: [String: Any] = [
            "email": self.email,
            "password": self.password
        ]
        guard let jsonBody = try? JSONSerialization.data(withJSONObject: requestBody, options: .sortedKeys) else { return }
        print("jsonBody inside login:\n", jsonBody)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody
        
        session.dataTask(with: request) { (data, response, error) in
            print("inside completion handler for User.login")
            let STATUS_CODE_200 = 200
            let ERROR_MESSAGE = "Sorry, unable to complete login"
            let SUCCESS_MESSAGE = "Login complete"
            
            // Check that HttpResponse's status code = 200
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == STATUS_CODE_200 else {
                    completionHandler(ERROR_MESSAGE)
                    return
            }
            // Check that data is available
            guard let data = data else {
                completionHandler(ERROR_MESSAGE)
                return
            }
            // Decode data and retrieve auth_token
            let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data)
            self.auth_token = loginResponse?.auth_token
            completionHandler(SUCCESS_MESSAGE)
        }.resume()
    }
}

struct LoginResponse: Decodable {
    var auth_token: String?
}
