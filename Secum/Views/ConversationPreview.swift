//
//  ConversationPreview.swift
//  Secum
//
//  Created by Chen Cen on 10/20/23.
//

import Foundation
import SwiftUI

struct ConversationPreview: View {
    let owner: User
    
    var body: some View {
        Text("Conversation preview for \(owner.nickname)")
    }
}
