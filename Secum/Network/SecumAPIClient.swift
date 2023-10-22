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
    
    static let shared = SecumAPIClient()
    
    static let logRaw: Bool = false
    
    static let base_url = "https://meichinijiuchiquba.com"
    static let username = "AlRYzmz0UoFeByEsbo31OejN55prHGNcX6wBAo5Y"
    static let password = "mcMdd8CZQvoJBE2CuSehkrLbkDfOv2LpPOThzC4VFXvruRfEMoBW2dyT57fy9o19yRAYQt9CVuHE11KsIWPDifYQHzmhn8zKcI6GEy8LAirJrz1VBaIrYVixrCogU4Xg"
    
    
    static let path_ping = base_url.with(path: "/api/posts/")
    static let path_register_user = base_url.with(path: "/api/users/")
    static let path_reqesut_access_code = base_url.with(path: "/api/users/get_access_code/")
    static let path_reqesut_access_token = base_url.with(path: "/api/o/token/")
    static let path_get_profile = base_url.with(path: "/api/users/get_profile/")
    static let path_load_bot_chats = base_url.with(path: "/api/users/load_bot_chats/")
    static let path_list_contacts = base_url.with(path: "/api/contacts/list_contact/")
    static let path_send_msg = base_url.with(path: "/api/messages/send_msg/")
    static let path_create_group = base_url.with(path: "/api/messages/create_grp/")
    
    
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
        ).response { response in
            if(SecumAPIClient.logRaw) {
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("\(LogConstants.secumAPIClient) - requesting \(SecumAPIClient.path_reqesut_access_token), got Raw Response: \(utf8Text)")
                }
            }
        }
        .validate()
        .publishDecodable(type: AccessToken.self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    
    func getProfile() -> AnyPublisher<Profile, AFError>  {
        return get(
            path: SecumAPIClient.path_get_profile
        )
    }
    
    func loadBotChats() -> AnyPublisher<Data?, AFError> {
        return postUnserialized(
            path: SecumAPIClient.path_load_bot_chats
        )
    }
    
    func listContacts() -> AnyPublisher<ContactInfos, AFError> {
        return get(path: SecumAPIClient.path_list_contacts)
    }
    
    func sendMessage(groupID: String, text: String) -> AnyPublisher<MessageResponse, AFError> {
        return post(
            path: SecumAPIClient.path_send_msg,
            params: [
                "msg_grp_id": Int(groupID)!,
                "text": text
            ]
        )
    }
    
    func createGroup(peerUserID: String) -> AnyPublisher<MessageGroup, AFError> {
        return post(
            path: SecumAPIClient.path_create_group,
            params: [
                "user_ids": [Int(peerUserID)]
            ]
        )
    }
}

extension SecumAPIClient {
    fileprivate func post<Output: Decodable>(path: URLConvertible, params: [String: Any] = [:], useAuthorization: Bool = true) -> AnyPublisher<Output, AFError> {
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
            if(SecumAPIClient.logRaw) {
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("\(LogConstants.secumAPIClient) - requesting \(path), got Raw Response: \(utf8Text)")
                }
            }
        }
        .validate()
        .publishDecodable(type: Output.self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    
    fileprivate func get<Output: Decodable>(path: URLConvertible, useAuthorization: Bool = true) -> AnyPublisher<Output, AFError> {
        var headers: HTTPHeaders = [
            "Content-type": "application/json",
        ]
        
        if (useAuthorization) {
            headers["Authorization"] = KeychainHelper.getAccessToken()
        }
        
        
        return AF.request(
            path,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).response { response in
            if(SecumAPIClient.logRaw) {
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("\(LogConstants.secumAPIClient) - requesting \(path), got Raw Response: \(utf8Text)")
                }
            }
        }
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
            headers["Authorization"] = KeychainHelper.getAccessToken()
        }
        
        
        return AF.request(
            path,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers
        ).response { response in
            if(SecumAPIClient.logRaw) {
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("\(LogConstants.secumAPIClient) - requesting \(path), got Raw Response: \(utf8Text)")
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
