//
//  ConversationPreviewView.swift
//  Secum
//
//  Created by Chen Cen on 10/1/23.
//

import Foundation
import SwiftUI

struct LoggedInView : View {
    
    @StateObject var viewModel = LoggedInViewModel()
    
    var body: some View {
        
        switch viewModel.state {
        case .loadding:
            ProgressView().onAppear{
                viewModel.initializeUser()
            }
        case .conversationPreview:
            Text("ConversationPreview")
            Button(action: {
                viewModel.listContacts()
            }) {
                Text("listContacts")
            }
        case .contacts(let contacts):
            Text("Contacts")
            List {
                ForEach(contacts, id: \.userId) { user in
                    Text(user.nickname)
                }
            }
            
        case .conversationDetail(let peerId, let groupId):
            Text("ConversationDetail with peerId: \(peerId), groupID: \(groupId)")
        case .error(let reason):
            Text("Error! \(reason)")
        }
        
    }
}

#Preview {
    LoggedInView(viewModel: LoggedInViewModel())
}
