//
//  GroupData+Secum.swift
//  Secum
//
//  Created by Chen Cen on 10/22/23.
//

import Foundation
import CoreData

extension GroupData {
    
    static func fetchBy(msgGrpId: String, context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> GroupData? {
        let request = GroupData.fetchRequest()
        request.predicate = NSPredicate(format: "msgGrpId == %@", msgGrpId)
        
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("GroupData User.fetchAll failed!")
        }
    }
    
    static func updateGroupData(msgGrpId: String, ownerId: String, peerId: String, context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        let request = GroupData.fetchRequest()
        request.predicate = NSPredicate(format: "msgGrpId == %@", msgGrpId)
        if let _ = try? context.fetch(request).first {
            // already existed
            return
        } else {
            let groupData = GroupData(context: context)
            groupData.msgGrpId = msgGrpId
            groupData.ownerId = ownerId
            groupData.peerId = peerId
            do {
                try context.save()
            } catch {
                fatalError("GroupData - failed to save group")
            }
        }
    }
    
    static func getGroupId(ownerId: String, peerId: String, context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> String {
        let request = GroupData.fetchRequest()
        request.predicate = NSPredicate(format: "ownerId == %@ AND peerId == %@", ownerId, peerId)
        
        if let group = try? context.fetch(request).first {
            return group.msgGrpId!
        } else {
            fatalError("can't find groupId with owner \(ownerId) and peer \(peerId)")
        }
    }
}
