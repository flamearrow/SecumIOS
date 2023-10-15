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
            print("\(LogConstants.secumState) - LoggedInViewModel state changed to \(state)")
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
            .flatMap { profile in
                self.currentUser = profile.userInfo
                return self.apiClient.loadBotChats()
            }.subscribeWithHanlders(cancellables: &subscriptions, onError: { error in
                self.state = .error(reason: "get profile or loadBotChats error: \(error)")
            }) { _ in
                self.state = .conversationPreview
            }
    }
}
