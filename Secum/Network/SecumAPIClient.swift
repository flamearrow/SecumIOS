//
//  SecumAPIClient.swift
//  Secum
//
//  Created by Chen Cen on 9/24/23.
//

import Foundation
import Alamofire
import Combine




final class SecumAPIClient : SecumAPIClientProtocol {
    static let base_url = "https://meichinijiuchiquba.com"
    static let username = "AlRYzmz0UoFeByEsbo31OejN55prHGNcX6wBAo5Y"
    static let password = "mcMdd8CZQvoJBE2CuSehkrLbkDfOv2LpPOThzC4VFXvruRfEMoBW2dyT57fy9o19yRAYQt9CVuHE11KsIWPDifYQHzmhn8zKcI6GEy8LAirJrz1VBaIrYVixrCogU4Xg"
    
    
    static let path_ping = base_url.with(path: "/api/posts/")
    static let path_register_user = base_url.with(path: "/api/users/")
    static let path_reqesut_access_code = base_url.with(path: "/api/users/get_access_code/")
    static let path_reqesut_access_token = base_url.with(path: "/api/o/token/")
    
    static let debug_access_token = "asdf"
    
    ///  ping server to see if we can get some responses
    func ping() -> AnyPublisher<Data?, AFError> {
        return postUnserialized(
            path: SecumAPIClient.path_ping
        )
        
//        let headers: HTTPHeaders = [
//            "Accept": "application/json",
//            "Authorization": SecumAPIClient.debug_access_token
//        ]
//        
//        return AF.request(
//            SecumAPIClient.path_ping,
//            method: .post,
//            headers: headers
//        )
//        .validate()
//        .publishUnserialized()
//        .value()
//        .receive(on: DispatchQueue.main)
//        .eraseToAnyPublisher()
    }
    
    /// phoneNumber needs to be +16314561234
    /// don't need authorization
    func registerUser(phoneNumber: String) -> AnyPublisher<User, AFError> {
        return post(
            path: SecumAPIClient.path_register_user,
            params: ["phone" : phoneNumber],
            useAuthorization: false
        )
        
//        let headers: HTTPHeaders = [
//            "Content-type": "application/json",
//        ]
//        
//        let params: [String: Any] = [
//            "phone" : phoneNumber
//        ]
//        return AF.request(
//            SecumAPIClient.path_register_user,
//            method: .post,
//            parameters: params,
//            encoding: JSONEncoding.default,
//            headers: headers
//        )
//        .validate()
//        .publishDecodable(type: User.self)
//        .value()
//        .receive(on: DispatchQueue.main)
//        .eraseToAnyPublisher()
    }
    
    // don't need authorization
    func requestAccessCode(phoneNumber: String) -> AnyPublisher<AccessCode, AFError> {
        
        return post(
            path: SecumAPIClient.path_reqesut_access_code,
            params: ["phone" : phoneNumber]
        )
        
//        let headers: HTTPHeaders = [
//            "Content-type": "application/json",
//        ]
//        
//        let params: [String: Any] = [
//            "phone" : phoneNumber
//        ]
//        return AF.request(
//            SecumAPIClient.path_reqesut_access_code,
//            method: .post,
//            parameters: params,
//            encoding: JSONEncoding.default,
//            headers: headers
//        )
//        .validate()
//        .publishDecodable(type: AccessCode.self)
//        .value()
//        .receive(on: DispatchQueue.main)
//        .eraseToAnyPublisher()
    }
    
    // don't need authorization
    // need username and password, use -d instead json as params
    func getAccessToken(phoneNumber: String, otp: String) -> AnyPublisher<AccessToken, AFError> {
        return AF.request(
            SecumAPIClient.path_reqesut_access_token,
            method: .post,
            parameters: [
                "grant_type": "password",
                "username": phoneNumber,
                "password": otp
            ],
            encoding: URLEncoding.default,
            headers: [
                .authorization(username: SecumAPIClient.username, password: SecumAPIClient.password)
            ]
        )
        .validate()
        .publishDecodable(type: AccessToken.self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func getProfile() {
        
    }
    
    func loadBotChats() {
        
    }
    
    func listContacts() {
        
    }
    
    func sendMessage() {
        
    }
}

extension SecumAPIClient {
    fileprivate func post<Output: Decodable>(path: URLConvertible, params: [String: Any] = [:], useAuthorization: Bool = true) -> AnyPublisher<Output, AFError> {
        var headers: HTTPHeaders = [
            "Content-type": "application/json",
        ]
        
        if (useAuthorization) {
            headers["Authorization"] = getAuthorization()
        }
        
        
        return AF.request(
            path,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .validate()
        .publishDecodable(type: Output.self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    fileprivate func postUnserialized(path: URLConvertible, params: [String: Any] = [:], useAuthorization: Bool = true) -> AnyPublisher<Data?, AFError> {
        var headers: HTTPHeaders = [
            "Content-type": "application/json",
        ]
        
        if (useAuthorization) {
            headers["Authorization"] = getAuthorization()
        }
        
        
        return AF.request(
            path,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .validate()
        .publishUnserialized()
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    fileprivate func getAuthorization() -> String {
        return SecumAPIClient.debug_access_token
    }
}

extension String {
    fileprivate func with(path: String) -> URL {
        return URL(string: self + path)!
    }
}
