//
//  ConversationPreviewView.swift
//  Secum
//
//  Created by Chen Cen on 10/1/23.
//

import Foundation
import SwiftUI

struct LoggedInView : View {
    
    @ObservedObject var viewModel = LoggedInViewModel()
    
    var body: some View {
        
        switch viewModel.state {
        case .conversationPreview:
            Text("ConversationPreview")
        case .contacts:
            Text("Contacts")
        case .conversationDetail(let peerId):
            Text("ConversationDetail with peerId: \(peerId)")
        }
        
    }
}

#Preview {
    LoggedInView(viewModel: LoggedInViewModel())
}
