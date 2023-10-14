//
//  LoggedInViewModel.swift
//  Secum
//
//  Created by Chen Cen on 10/1/23.
//

import Foundation
import Combine

class LoggedInViewModel : ObservableObject {
    @Published var state: State = .loadding {
        didSet {
            if state == State.conversationPreview {
                print("BGLM - conversationPreview: curentuser: \(currentUser)")
            }
        }
    }
    
    private var subscriptions: Set<AnyCancellable> = []
    enum State: Equatable {
        case loadding
        case conversationPreview
        case contacts
        case conversationDetail(peerId: String)
        case error(reason: String)
    }
    
    private let apiClient : SecumAPIClientProtocol
    private var currentUser: User?
    
    init() {
        apiClient = SecumAPIClient.shared
    }
    
    // getProfile, then load bots
    func initializeUser() {
        apiClient.getProfile()
            .sink { [weak self] receiveCompletion in
                switch receiveCompletion {
                case .failure(let error):
                    self?.state = .error(reason: "get profile error: \(error)")
                case .finished:
                    break
                }
            } receiveValue: {[weak self] profile in
                guard let self = self else { return }
                self.currentUser = profile.userInfo
                
                self.apiClient.loadBotChats()
                    .sink{ [weak self] receiveCompletion in
                        switch receiveCompletion {
                        case .failure(let error):
                            self?.state = .error(reason: "load bot chats error: \(error)")
                        case .finished:
                            break
                        }
                    } receiveValue: { _ in
                        self.state = .conversationPreview
                    }.store(in: &subscriptions)
                
            }.store(in: &subscriptions)
        
    }
    
    
    
    
    
}
