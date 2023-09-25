//
//  ContentViewModel.swift
//  Secum
//
//  Created by Chen Cen on 9/24/23.
//

import Foundation
import Combine

class ContentViewModel : ObservableObject {
    @Published var phoneNumber = ""
    @Published var state: State = .splash {
        didSet {
            print("BGLM - state changed to \(state)")
        }
    }
    
    enum State {
        case splash
        case loading
        case login
        case conversationPreview
        case contacts
        case conversationDetail(peerID: String)
    }
    
    private let apiClient : SecumAPIClientProtocol
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
        self.apiClient = SecumAPIClient()
    }
    
    func tryPing() {
        self.state = .loading
        
        apiClient.ping()
            .sink { [weak self] receiveCompletion in
                guard let self = self else {return}
                switch receiveCompletion {
                    case .failure(let error):
                        print("BGLM - \(error)")
                    case .finished:
                        print("BGLM - finished")
                }
            } receiveValue: { value in
                print("BGLM - value: \(String(describing: value))")
            }
            .store(in: &subscriptions) // place holder always required
    }
    
}
