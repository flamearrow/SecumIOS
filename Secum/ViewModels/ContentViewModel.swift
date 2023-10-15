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
            print("\(LogConstants.secumState) - ContentViewModel state changed to \(state)")
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
        apiClient.ping()
            .subscribeWithHanlders(cancellables: &subscriptions, onError: { error in
                if (error.isResponseValidationError) {
                    self.state = .login
                } else {
                    self.state = .error
                }
            }) { _ in
                self.state = .loggedIn
            }
    }
}
