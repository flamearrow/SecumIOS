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
    static func updateMessageData(ownerId: String, from pubNubMessage: PubNubMessage, context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        let decoder = JSONDecoder()
        do {
            let pnMessage = try decoder.decode(PNMessage.self, from: pubNubMessage.payload.jsonData!)
            
            let messageData = MessageData(context: context)
            messageData.messageId = UUID().uuidString
            messageData.groupId = String(pnMessage.packet.msgGroupId)
            messageData.content = pnMessage.packet.message.text
            messageData.imageUrl = pnMessage.packet.message.picture
            messageData.read = false
            messageData.time = Int64(pubNubMessage.published)
            messageData.from = UserData.fetchBy(userId: String(pnMessage.senderId))
            messageData.owner = UserData.fetchBy(userId: ownerId)
            messageData.to = UserData.fetchBy(userId: ownerId)
            try context.save()
        } catch {
            print("MessageData - failed to decode pubNubMessage \(pubNubMessage) with error \(error)")
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
    
    static func messageOwnedBy(
        owner: String,
        context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    ) -> NSFetchRequest<MessageData> {
        let request = MessageData.fetchRequest()
        if let ownerUser = UserData.fetchBy(userId: owner) {
            request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
            request.predicate = NSPredicate(format: "owner = %@", ownerUser)
            return request
        } else {
            fatalError("can't find ownerUser with \(owner)")
        }
    }
    
    func peerId() -> String {
        if let groupData = GroupData.fetchBy(msgGrpId: self.groupId!) {
            return groupData.peerId!
        } else {
            fatalError("failed to get peerId")
        }
    }
    
    func peerName() -> String {
        if let groupData = GroupData.fetchBy(msgGrpId: self.groupId!) {
            let peerUser = UserData.fetchBy(userId: groupData.peerId!)
            return (peerUser?.nickname!)!
        } else {
            fatalError("failed to get peerId")
        }
    }
    
    func isFromOwner() -> Bool {
        return self.owner == self.from
    }
    
    static func lastMessageTime(on channel: String, 
                             context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> Int64 {
        guard let ownerUser = UserData.fetchBy(userId: channel)else {
            fatalError("can't find ownerUser with \(channel)")
        }
        
        let request = MessageData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        request.predicate = NSPredicate(format: "owner = %@", ownerUser)
        if let lastMessage = try? context.fetch(request).last {
            return lastMessage.time
        } else {
            print("MessageData - didn't find message on channel \(channel)")
            return 0
        }
    }
}
