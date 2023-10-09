//
//  LoggedInViewModel.swift
//  Secum
//
//  Created by Chen Cen on 10/1/23.
//

import Foundation

class LoggedInViewModel : ObservableObject {
    @Published var state: State = .conversationPreview
    
    enum State {
        case conversationPreview
        case contacts
        case conversationDetail(peerId: String)
    }
    
}
