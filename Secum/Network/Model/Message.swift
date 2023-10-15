//
//  Message.swift
//  Secum
//
//  Created by Chen Cen on 10/15/23.
//

import Foundation
import CoreData


struct Message : Codable, Equatable, Hashable {
    let content: String?
    let groupId: String?
    let ImageUrl: String?
    let messageId: String?
    let read: Bool?
    let time: Int64?
    
}

//class Message : NSManagedObject, Codable {
//    
//    // required for Encodable
//    required convenience public init(from decoder: Decoder) throws {
//        // First read the custom NSManagedObjectContext object attached to decoder
//        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
//            fatalError()
//        }
//        // Then call the constructor of NSManageObject to construct
//        self .init(context: context)
//        
//        // then actually decode the values from decoder to the fields
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//            
//        // populate the attributes defined in xcdatamodel
//        content = try container.decode(String.self, forKey: .content)
//        groupId = try container.decode(String.self, forKey: .groupId)
//        imageUrl = try container.decode(String.self, forKey: .imageUrl)
//        messageId = try container.decode(String.self, forKey: .messageId)
//        read = try container.decode(Bool.self, forKey: .read)
//        time = try container.decode(Int64.self, forKey: .time)
//        
//    }
//    
//    // required for Decodable
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(content, forKey: .content)
//        try container.encode(groupId, forKey: .groupId)
//        try container.encode(imageUrl, forKey: .imageUrl)
//        try container.encode(messageId, forKey: .messageId)
//        try container.encode(read, forKey: .read)
//        try container.encode(time, forKey: .time)
//    }
//    
//    enum CodingKeys: CodingKey {
//        case content, groupId, imageUrl, messageId, read, time
//    }
//}
