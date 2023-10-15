//
//  CoreDataRepository.swift
//  Secum
//
//  Created by Chen Cen on 10/15/23.
//

import Foundation
import CoreData

struct CoreDataRepository {
    init() {
        let container = NSPersistentContainer(name: "SecumCoreData")
        let context = container.viewContext
    }
}
