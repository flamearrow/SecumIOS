//
//  LoginViewModel.swift
//  Secum
//
//  Created by Chen Cen on 9/25/23.
//

import Foundation
import Combine
import SwiftKeychainWrapper

class LoginViewModel : ObservableObject {
    @Published var state: State = .inputtingPhoneNumber(loading: false) {
        didSet {
            print("\(LogConstants.secumState) - LoginViewModel state changed to \(state)")
        }
    }
    @Published var phoneNumerIsValid : Bool = false
    @Published var otp: AccessCode? = nil
    
    private let apiClient : SecumAPIClientProtocol
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private var phoneNumber: String? = nil
    
    enum State {
        case inputtingPhoneNumber(loading: Bool)
        case inputtingAccessCode(phoneNumber: String, loading: Bool)
        case error(reason: String)
        case gotAccessToken
    }
    
    init() {
        self.apiClient = SecumAPIClient.shared
    }
    
    func registerUserAndRequestAccessCode(fullPhoneNumber: String) {
        self.state = .inputtingPhoneNumber(loading: true)
        apiClient.registerUser(phoneNumber: fullPhoneNumber)
            .flatMap { _ in
                // no need to save user, will get through Profile in LoggedInView
                return self.apiClient.requestAccessCode(phoneNumber: fullPhoneNumber)
            }
            .subscribeWithHanlders(cancellables: &subscriptions, onError: { error in
                self.state = .error(reason: "register user or request access code error: \(error)")
            }) { accessCode in
                self.phoneNumber = fullPhoneNumber
                self.otp = accessCode
                self.state = .inputtingAccessCode(phoneNumber: fullPhoneNumber, loading: false)
            }
    }
    
    func getAndSaveAccessToken() {
        self.state = .inputtingAccessCode(phoneNumber: phoneNumber!, loading: true)
        guard let otp = self.otp, let phoneNumber = self.phoneNumber else {
            self.state = .error(reason: "otp or phoneNumber is nil")
            return
        }
        
        apiClient.getAccessToken(phoneNumber: phoneNumber, otp: otp.accessCode)
            .subscribeWithHanlders(cancellables: &subscriptions, onError: { error in
                self.state = .error(reason: "get access token error: \(error)")
            }) { accessToken in
                guard KeychainHelper.saveAccessToken(accessToken: accessToken.access_token) == true
                else{
                    self.state = .error(reason: "failed to write token")
                    return
                }
                self.state = .gotAccessToken
            }
    }
}
