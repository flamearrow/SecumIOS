//
//  ConversationViewModel.swift
//  Secum
//
//  Created by Chen Cen on 10/21/23.
//

import Foundation
import Combine


class ConversationViewModel : ObservableObject {
    @Published var state: State = .loaded
    let groupId: String
    
    enum State {
        case loaded
        case error(reason: String)
    }
    
    private let apiClient: SecumAPIClientProtocol
    private let peerId: String
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(ownerId: String, peerId: String) {
        apiClient = SecumAPIClient.shared
        self.groupId = GroupData.getGroupId(ownerId: ownerId, peerId: peerId)
        self.peerId = peerId
    }
    
    func sendMessage(msg: String) {
        apiClient.sendMessage(
            groupID: groupId,
            text: msg
        ).subscribeWithHanlders(
            cancellables: &subscriptions
        ) { error in
            self.state = .error(reason: "failed to send message")
        } onSuccess: { result in
            // no-op
        }
    }
}
