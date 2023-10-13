//
//  KeychainHelper.swift
//  Secum
//
//  Created by Chen Cen on 10/13/23.
//

import Foundation
import SwiftKeychainWrapper


struct KeychainHelper {
    private static  let secumOAuth2Token: String = "secumOAuth2Token"

    static func saveAccessToken(accessToken: String) -> Bool {
        return KeychainWrapper.standard.set(accessToken, forKey: secumOAuth2Token)
    }

    static func getAccessToken() -> String {
        return "Bearer " + (KeychainWrapper.standard.string(forKey: secumOAuth2Token) ?? "")
    }
}
