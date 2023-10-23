//
//  PubNubController.swift
//  Secum
//
//  Created by Chen Cen on 10/22/23.
//

import Foundation
import PubNub

class PubNubController {
    
    static let shared = PubNubController()
    
    public static let PUB_KEY = "pub-c-f8c4ff9c-5f67-4e3f-8500-2ba2c5f783f0";
    public static let SUB_KEY = "sub-c-65ab1c78-f6fd-11e6-ac91-02ee2ddab7fe";
    
    let pubnub: PubNub
    // This needs to be held explictly as a strong reference, can't just initilize it as temp object inside init()
    let listener: SubscriptionListener
    
    var ownerId: String?
    
    init() {
        self.pubnub = PubNub(
            configuration: .init(
                publishKey: PubNubController.PUB_KEY,
                subscribeKey: PubNubController.SUB_KEY,
                userId: UUID().uuidString
            )
        )
        listener = SubscriptionListener()
        listener.didReceiveMessage = onPnMessage
        pubnub.add(listener)
    }
    
    func subscribe(channel: String) {
        self.ownerId = channel
        pubnub.subscribe(to: [channel])
        
    }
    
    private func onPnMessage(message: PubNubMessage) {
        guard let ownerId = self.ownerId else {
            print("PubNubController - ownerId is nil")
            return
        }
        MessageData.updateMessageData(ownerId: ownerId, from: message)
    }
}
