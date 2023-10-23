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
        case loaded(currentuser: User)
        case error(reason: String)
    }
    
    private let apiClient : SecumAPIClientProtocol
    private let persistenceController : PersistenceController = PersistenceController.shared
    
    private var user: User?
    init() {
        apiClient = SecumAPIClient.shared
    }
    
    // getProfile, then load bots
    func initializeUser() {
        apiClient.getProfile()
            .flatMap { profile in
                self.user = profile.userInfo
                _ = UserData.updateUserData(from: profile.userInfo)
                return self.apiClient.loadBotChats()
            }.flatMap { _ in
                return self.apiClient.listContacts()
            }.subscribeWithHanlders(cancellables: &subscriptions, onError: { error in
                self.state = .error(reason: "initilizeUser error: \(error)")
            }) { contacts in
                guard let user = self.user else {
                    self.state = .error(reason: "self.user is nill in listContacts")
                    return
                }
                let contacts: [User] = Array(contacts.contactInfos.map{$0.userInfo})
                UserData.updateContacts(for: user, contacts: contacts)
                
                PubNubController.shared.subscribe(channel: user.userId)
                self.state = .loaded(currentuser: user)
            }
    }
}
