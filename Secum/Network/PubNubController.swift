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
    
    func subscribe(channel: String, since: Int64) {
        self.ownerId = channel
        // +1 to not reteive the last one
        retriveOldMessages(channel: channel, since: since + 1)
        pubnub.subscribe(to: [channel])
    }
    
    private func retriveOldMessages(channel: String, since: Int64) {
        // if since > 0 retrieve all messages we can get
        doRetrieve(
            channel: channel,
            pnPage: PubNubBoundedPageBase(
                end: UInt64(since)
            )
        )
    }
    
    private func doRetrieve(channel: String, pnPage: PubNubBoundedPage?) {
        if let pnPage = pnPage {
            pubnub.fetchMessageHistory(
                for: [channel],
                page: pnPage
            ) { result in
                switch result {
                case let .success(response):
                    response.messagesByChannel[channel]?.forEach { oldMsg in
                        MessageData.updateMessageData(ownerId: channel, from: oldMsg)
                    }
                    self.doRetrieve(channel: channel, pnPage: response.next)
                case let .failure(error):
                    print("Failed History Fetch Response: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    private func onPnMessage(message: PubNubMessage) {
        guard let ownerId = self.ownerId else {
            print("PubNubController - ownerId is nil")
            return
        }
        MessageData.updateMessageData(ownerId: ownerId, from: message)
    }
}
