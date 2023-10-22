//
//  User.swift
//  Secum
//
//  Created by Chen Cen on 9/25/23.
//

import Foundation
import CoreData
import SwiftUI

struct User : Codable, Equatable, Hashable {
    let userId: String
    let nickname: String
}


extension User {
    func messagesWith(peerId: String, context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> NSFetchRequest<MessageData> {
        return MessageData.messages(ownerId: self.userId, peerId: peerId, context: context)
    }
}
