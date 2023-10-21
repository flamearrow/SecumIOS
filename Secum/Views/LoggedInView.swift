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
    
    @State var selection = conversationPreviewTag
    
    static let conversationPreviewTag = 1
    static let botsTag = 2
    
    var body: some View {
        
        switch viewModel.state {
        case .loadding:
            ProgressView().onAppear{
                viewModel.initializeUser()
            }
        case .loaded(let currentUser):
            TabView(selection: $selection) {
                ConversationPreview(owner: currentUser)
                    .tabItem {
                        Label(LocalizedStringKey("conversation"), systemImage: "message")
                    }
                    .tag(LoggedInView.conversationPreviewTag)
                
                ContactsView(owner: currentUser)
                    .tabItem {
                        Label(LocalizedStringKey("contacts"), systemImage: "person.3")
                    }
                    .tag(LoggedInView.conversationPreviewTag)
                
            }
        case .error(let reason):
            Text("Error! \(reason)")
        }
        
    }
}

#Preview {
    LoggedInView(viewModel: LoggedInViewModel())
}
