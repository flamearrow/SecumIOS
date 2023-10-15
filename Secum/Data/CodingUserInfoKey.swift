//
//  CodingUserInfoKey.swift
//  Secum
//
//  Created by Chen Cen on 10/16/23.
//

import Foundation

extension CodingUserInfoKey {
    // the key used to attach custom object to decoder
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
