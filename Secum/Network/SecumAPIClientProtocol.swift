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
    func ping() -> AnyPublisher<Data?, AFError>
    func registerUser(phoneNumber: String) -> AnyPublisher<User, AFError>
    func requestAccessCode(phoneNumber: String) -> AnyPublisher<AccessCode, AFError>
    func getAccessToken(phoneNumber: String, otp: String) -> AnyPublisher<AccessToken, AFError>
    func getProfile() -> AnyPublisher<Profile, AFError>
    func loadBotChats() -> AnyPublisher<Data?, AFError>
    func listContacts() -> AnyPublisher<ContactInfos, AFError>
    func sendMessage(groupID: String, text: String) -> AnyPublisher<MessageResponse, AFError>
    func createGroup(peerUserID: String) -> AnyPublisher<MessageGroup, AFError>
}
