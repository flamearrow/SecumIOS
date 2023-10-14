//
//  SecumAPIClientProtocol.swift
//  Secum
//
//  Created by Chen Cen on 9/24/23.
//

import Foundation
import Combine
import Alamofire

protocol SecumAPIClientProtocol {
    func ping() -> AnyPublisher<Data?, AFError> // 1, done
    func registerUser(phoneNumber: String) -> AnyPublisher<User, AFError> // 7, done
    func requestAccessCode(phoneNumber: String) -> AnyPublisher<AccessCode, AFError> // 8, done
    func getAccessToken(phoneNumber: String, otp: String) -> AnyPublisher<AccessToken, AFError> // 6, done
    func getProfile() -> AnyPublisher<Profile, AFError>  // 2
    func loadBotChats() -> AnyPublisher<Data?, AFError> // 3
    func listContacts() // 4
    func sendMessage() // 5
}
