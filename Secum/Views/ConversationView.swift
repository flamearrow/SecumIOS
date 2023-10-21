//
//  ConversationView.swift
//  Secum
//
//  Created by Chen Cen on 10/20/23.
//

import Foundation
import SwiftUI

struct ConversationView: View {
    let owner: User
    let peerId: String
    
    @Binding var shouldShowTabBar: Bool
    
    var body: some View {
        Text("conversation between owner: \(owner.userId) and peer: \(peerId)")
            .onAppear {
                shouldShowTabBar = false
            }
            .onDisappear{
                shouldShowTabBar = true
            }
    }
}
