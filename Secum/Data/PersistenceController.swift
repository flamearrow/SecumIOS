//
//  PersistenceController.swift
//  Secum
//
//  Created by Chen Cen on 10/16/23.
//

import CoreData

/// Controller to configure Coredata
class PersistenceController: ObservableObject {
    static let shared = PersistenceController()
    static let preview = PersistenceController(inMemory: true)
    
    let container: NSPersistentContainer
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SecumCoreData")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error when initializing loadPersistentStores \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                fatalError("Failed saveContext")
            }
        }
    }
}
