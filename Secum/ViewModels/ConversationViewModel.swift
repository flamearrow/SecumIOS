//
//  ConversationViewModel.swift
//  Secum
//
//  Created by Chen Cen on 10/21/23.
//

import Foundation
import Combine


class ConversationViewModel : ObservableObject {
    @Published var state: State = .loading
    @Published var groupId: String = ""
    
    enum State {
        case loading
        case loaded
        case error(reason: String)
    }
    
    private let apiClient: SecumAPIClientProtocol
    private let peerId: String
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init(ownerId: String, peerId: String) {
        apiClient = SecumAPIClient.shared
        self.peerId = peerId
    }
    
    func createGroup() {
        apiClient
            .createGroup(peerUserID: peerId)
            .subscribeWithHanlders(
                cancellables: &subscriptions
            ) { error in
                self.state = .error(reason: "failed to create group with peer \(self.peerId)")
            } onSuccess: { [weak self] messageGroup in
                self?.groupId = messageGroup.msgGrpId
                self?.state = .loaded
            }
    }
    
    func sendMessage(msg: String) {
//        guard let groupId = self.groupId else {
//            self.state = .error(reason: "self group id is nil")
//            return
//        }
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
