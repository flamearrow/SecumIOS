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
    }
    
    /// phoneNumber needs to be +16314561234
    /// don't need authorization
    func registerUser(phoneNumber: String) -> AnyPublisher<User, AFError> {
        return post(
            path: SecumAPIClient.path_register_user,
            params: ["phone" : phoneNumber],
            useAuthorization: false
        )
    }
    
    // don't need authorization
    func requestAccessCode(phoneNumber: String) -> AnyPublisher<AccessCode, AFError> {
        
        return post(
            path: SecumAPIClient.path_reqesut_access_code,
            params: ["phone" : phoneNumber],
            useAuthorization: false
        )
        
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
    fileprivate func post<Output: Decodable>(path: URLConvertible, params: [String: Any] = [:], useAuthorization: Bool = true, logRaw: Bool = false) -> AnyPublisher<Output, AFError> {
        var headers: HTTPHeaders = [
            "Content-type": "application/json",
        ]
        
        if (useAuthorization) {
            headers["Authorization"] = KeychainHelper.getAccessToken()
        }
        
        
        return AF.request(
            path,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers
        ).response { response in
            if(logRaw) {
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("BGLM - requesting \(path), got Raw Response: \(utf8Text)")
                }
            }
        }
        .validate()
        .publishDecodable(type: Output.self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    fileprivate func postUnserialized(path: URLConvertible, params: [String: Any] = [:], useAuthorization: Bool = true, logRaw: Bool = false) -> AnyPublisher<Data?, AFError> {
        var headers: HTTPHeaders = [
            "Content-type": "application/json",
        ]
        
        if (useAuthorization) {
            headers["Authorization"] = KeychainHelper.getAccessToken()
        }
        
        
        return AF.request(
            path,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers
        ).response { response in
            if(logRaw) {
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("BGLM - requesting \(path), got Raw Response: \(utf8Text)")
                }
            }
        }
        .validate()
        .publishUnserialized()
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
}

extension String {
    fileprivate func with(path: String) -> URL {
        return URL(string: self + path)!
    }
}
