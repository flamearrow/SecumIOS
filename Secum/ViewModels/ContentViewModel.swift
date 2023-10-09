//
//  ContentViewModel.swift
//  Secum
//
//  Created by Chen Cen on 9/24/23.
//

import Foundation
import Combine

class ContentViewModel : ObservableObject {
    @Published var phoneNumber = ""
    @Published var state: State = .splash {
        didSet {
            print("BGLM - state changed to \(state)")
        }
    }
    
    enum State {
        case splash
        case loading
        case error
        case login
        case loggedIn
    }
    
    private let apiClient : SecumAPIClientProtocol
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
        self.apiClient = SecumAPIClient()
    }
    
    func tryPing() {
        self.state = .loading
        apiClient.ping()
            .sink { [weak self] receiveCompletion in
                guard let self = self else { return }
                switch receiveCompletion {
                case .failure(let error):
                    if (error.isResponseValidationError) {
                        self.state = .login
                    } else {
                        self.state = .error
                    }
                case .finished:
                    break
                }
            } receiveValue: { value in
                // getProfile and loadBotChat, then set state
                self.state = .loggedIn
            }
            .store(in: &subscriptions) // place holder always required
    }
    
}
