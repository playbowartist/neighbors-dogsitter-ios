//
//  Authentication.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 6/18/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

//import Foundation
//
//typealias registerHandler = (Result<User, Error>) -> Void
//
//protocol AuthenticationAPIProtocol {
//    
//    func register(withEmail email: String, password: String,
//                  then handler: @escaping registerHandler)
//    
//}
//
//
//import FirebaseAuth
//
//class FirebaseAuthentication: AuthenticationAPIProtocol {
//    
//    func register(withEmail email: String, password: String, then handler: @escaping registerHandler) {
//        
//        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
//            
//            if let error = error {
//                handler(.failure(error))
//            }
//            
//            if let authResult = authResult {
//                
//                var user = User()
//                user.email = authResult.user.email
//                user.password = password
//                user.firebaseID = authResult.user.uid
//                
//                handler(.success(user))
//
//            }
//        }
//    }
//    
//}
