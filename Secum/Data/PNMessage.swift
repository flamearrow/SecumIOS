//
//  PNMessage.swift
//  Secum
//
//  Created by Chen Cen on 10/22/23.
//

import Foundation

struct PNMessage: Codable {
    let packet: PNPacket
    let senderId: Int
}

struct PNPacket: Codable {
    let senderId: Int
    let message: MessagePayLoad
    let time: Int64
    let msgGroupId: Int
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            senderId = try container.decode(Int.self, forKey: .senderId)
            time = try container.decode(Int64.self, forKey: .time)
            msgGroupId = try container.decode(Int.self, forKey: .msgGroupId)
            
            let messageString = try container.decode(String.self, forKey: .message)
            if let messageData = messageString.data(using: .utf8) {
                message = try JSONDecoder().decode(MessagePayLoad.self, from: messageData)
            } else {
                throw DecodingError.dataCorruptedError(forKey: .message, in: container, debugDescription: "Message string could not be converted to Data")
            }
        }
}

struct MessagePayLoad: Codable {
    let text: String?
    let picture: String?
}
