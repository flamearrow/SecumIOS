//
//  ConversationPreview.swift
//  Secum
//
//  Created by Chen Cen on 10/20/23.
//

import Foundation
import SwiftUI

struct ConversationPreview: View {
    @FetchRequest var ownedMessages: FetchedResults<MessageData>
    @State private var shouldShowTabBar = true
    private let owner: User
    
    private var previewMessages: [MessageData] {
        // group previews by groupId
        // then for each group find the last message
        let groupedMessages = Dictionary(grouping: ownedMessages, by: {$0.groupId})
        
        return groupedMessages.values.compactMap { group in
            return group.max(by: {$0.time < $1.time})
        }
        
    }
    
    
    init(owner: User) {
        self.owner = owner
        self._ownedMessages = FetchRequest(fetchRequest: owner.messages())
    }
    
    var body: some View {
        NavigationView {
            List(previewMessages) { previewMessage in
                NavigationLink(destination: ConversationView(owner: owner, peerId: previewMessage.peerId(), shouldShowTabBar: $shouldShowTabBar)) {
                    PreviewItem(contactName: previewMessage.peerName(), lastMessage: previewMessage.content!)
                }
            }
        }.toolbar(shouldShowTabBar ? .visible : .hidden, for: .tabBar)
    }
}

struct PreviewItem: View {
    let contactName: String
    let lastMessage: String
    
    var body: some View {
        VStack(
            alignment: .leading
        ) {
            Text(contactName).font(.title3).bold().padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            Text(lastMessage)
        }
    }
    
}

#Preview {
    PreviewItem(contactName: "contact name", lastMessage: "this is the last message sent")
}

