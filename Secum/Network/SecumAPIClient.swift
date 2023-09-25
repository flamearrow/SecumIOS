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
    
    static let path_ping = "/api/posts/"
    
    static let debug_access_token = "asdf"
    
    ///  ping server to see if we can get some responses
    func ping() -> AnyPublisher<Data?, AFError> {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization": SecumAPIClient.debug_access_token
        ]
        
        return AF.request(
            SecumAPIClient.base_url.with(path: SecumAPIClient.path_ping),
            method: .post,
            headers: headers
        )
        .validate()
        .publishUnserialized()
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func registerUser() {
        
    }
    
    func requestAccessCode() {
        
    }
    
    func getAccessToken() {
        
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

extension String {
    fileprivate func with(path: String) -> URL {
        return URL(string: self + path)!
    }
}
