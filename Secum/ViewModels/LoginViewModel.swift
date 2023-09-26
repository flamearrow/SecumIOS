//
//  LoginViewModel.swift
//  Secum
//
//  Created by Chen Cen on 9/25/23.
//

import Foundation
import Combine

class LoginViewModel : ObservableObject {
    @Published var state: State = .inputtingPhoneNumber
    @Published var phoneNumerIsValid : Bool = false
    
    private let apiClient : SecumAPIClientProtocol
    
    private var subscriptions: Set<AnyCancellable> = []
    
    enum State {
        case inputtingPhoneNumber
        case inputtingAccessCode
        case loading
        case error(reason: String)
    }
    
    init() {
        self.apiClient = SecumAPIClient()
    }
    
    func registerUserAndRequestAccessCode(fullPhoneNumber: String) {
        self.state = .loading
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
                print("BGLM - got user! \(user), to requestAccessCode")
                self.apiClient.requestAccessCode() // return corrected accessCode
            }
            .store(in: &subscriptions)
        
        
        
    }
}
