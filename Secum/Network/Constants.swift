//
//  Constants.swift
//  Secum
//
//  Created by Chen Cen on 10/15/23.
//

import Foundation

struct NetworkConstants {
    static let chatGPT: String = "ChatGPT"
    static let chatGPTID: String = "13"
    static let chatGPTNickName: String = "Bot:phone_+6661"
    static let midjourney: String = "Midjourney"
    static let midjourneyID: String = "18"
    static let midjourneyNickName: String = "Bot:phone_+6662"
}

extension String? {
    func nickNameToBotName() -> String {
        switch self {
        case NetworkConstants.chatGPTNickName:
            return NetworkConstants.chatGPT
        case NetworkConstants.midjourneyNickName:
            return NetworkConstants.midjourney
        default:
            return ""
        }
    }
}
