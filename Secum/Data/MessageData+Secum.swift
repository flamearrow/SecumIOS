//
//  MessageData+Secum.swift
//  Secum
//
//  Created by Chen Cen on 10/21/23.
//

import Foundation
import CoreData
import PubNub

extension MessageData {
    static func updateMessageData(ownerId: String, from pnMessage: PubNubMessage, context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        let decoder = JSONDecoder()
        do {
            let pnMessage = try decoder.decode(PNMessage.self, from: pnMessage.payload.jsonData!)
            
            let messageData = MessageData(context: context)
            messageData.messageId = UUID().uuidString
            messageData.groupId = String(pnMessage.packet.msgGroupId)
            messageData.content = pnMessage.packet.message.text
            messageData.imageUrl = pnMessage.packet.message.picture
            messageData.read = false
            messageData.time = pnMessage.packet.time
            messageData.from = UserData.fetchBy(userId: String(pnMessage.senderId))
            messageData.owner = UserData.fetchBy(userId: ownerId)
            messageData.to = UserData.fetchBy(userId: ownerId)
            try context.save()
        } catch {
            print("MessageData - failed to decode pnMessage \(pnMessage) with error \(error)")
        }
    }
        
    static func emptyRequest() -> NSFetchRequest<MessageData> {
        let request = MessageData.fetchRequest()
        request.predicate = NSPredicate(value: false)
        return request
    }
    
    static func messages(
        ownerId: String,
        peerId: String,
        context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    ) -> NSFetchRequest<MessageData> {
        guard let ownerUser = UserData.fetchBy(userId: ownerId), let peerUser = UserData.fetchBy(userId: peerId) else {
            fatalError("can't find ownerUser with \(ownerId) or peerUser with \(peerId)")
        }
        
        let request = MessageData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        request.predicate = NSPredicate(format: "owner = %@ AND (to = %@ OR from = %@)", ownerUser, peerUser, peerUser)
        return request
    }
    
    static func messages(
        groupId: String,
        context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    ) -> NSFetchRequest<MessageData> {
        let request = MessageData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        request.predicate = NSPredicate(format: "groupId = %@", groupId)
        return request
    }
    
    func isFromOwner() -> Bool {
        return self.owner == self.from
    }
}

private extension String? {
    
}
