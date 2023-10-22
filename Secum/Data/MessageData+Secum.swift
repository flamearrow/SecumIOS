//
//  MessageData+Secum.swift
//  Secum
//
//  Created by Chen Cen on 10/21/23.
//

import Foundation
import CoreData

extension MessageData {
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
    
    func isFromOwner() -> Bool {
        return self.owner == self.from
    }
}
