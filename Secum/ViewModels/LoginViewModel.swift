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
            print("BGLM - state just changed to \(state)")
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
            .sink { [weak self] receiveCompletion in
                guard let self = self else { return }
                switch receiveCompletion {
                case .failure(let error):
                    self.state = .error(reason: "register user error: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { user in
                self.apiClient.requestAccessCode(phoneNumber: fullPhoneNumber)
                    .sink { [weak self] receiveCompletion in
                        guard let self = self else { return }
                        switch receiveCompletion {
                        case .finished:
                            break
                        case .failure(let error):
                            self.state = .error(reason: "request access code error: \(error)")
                        }
                    } receiveValue: { accessCode in
                        self.phoneNumber = fullPhoneNumber
                        self.otp = accessCode
                        self.state = .inputtingAccessCode(phoneNumber: fullPhoneNumber, loading: false)
                    }
                    .store(in: &self.subscriptions)
            }
            .store(in: &subscriptions)
    }
    
    func getAndSaveAccessToken() {
        self.state = .inputtingAccessCode(phoneNumber: phoneNumber!, loading: true)
        guard let otp = self.otp, let phoneNumber = self.phoneNumber else {
            self.state = .error(reason: "otp or phoneNumber is nil")
            return
        }
        apiClient.getAccessToken(phoneNumber: phoneNumber, otp: otp.accessCode)
            .sink { [weak self] receiveCompletion in
                guard let self = self else { return }
                switch receiveCompletion {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .error(reason: "get access token error: \(error)")
                }
            } receiveValue: { accessToken in
                guard KeychainHelper.saveAccessToken(accessToken: accessToken.access_token) == true
                else{
                    self.state = .error(reason: "failed to write token")
                    return
                }
                self.state = .gotAccessToken
            }
            .store(in: &self.subscriptions)
    }
}
