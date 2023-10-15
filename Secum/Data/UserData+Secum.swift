//
//  UserData+Secum.swift
//  Secum
//
//  Created by Chen Cen on 10/17/23.
//

import Foundation
import CoreData

extension UserData {
    private static let logTag:String = "UserData"
    
    static func fetchBy(userId: String) -> UserData? {
        let request = UserData.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId)

        do {
            return try PersistenceController.shared.container.viewContext.fetch(request).first
        } catch {
            fatalError("\(logTag) User.fetchAll failed!")
        }
    }
    
    /// Create a new UserData or update existing one based on userResponse
    static func updateUserData(from userResponse: User, instantSave: Bool = true) -> UserData? {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest = UserData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId == %@", userResponse.userId)
        
        
        do {
            let matchingUsers = try context.fetch(fetchRequest)
            let user: UserData
            if let existingUser = matchingUsers.first {
                user = existingUser
            } else {
                user = UserData(context: context) // calling this constrctor will trigger creation, use context.save() to commit it
            }
            
            user.userId = userResponse.userId
            user.nickname = userResponse.nickname
            
            if (instantSave) {
                do {
                    try context.save()
                } catch {
                    fatalError("\(logTag) failed to save update contacts")
                }
            }
            return user
        } catch {
            print("\(logTag) Failed to fetch or save user: \(error)")
            return nil
        }
    }
    
    /// Insert all contacts into UserData, then set them as the current user's contacts
    static func updateContacts(for userResponse: User, contacts: [User]) {
        guard !contacts.isEmpty else {
            return
        }
        let context = PersistenceController.shared.container.viewContext
        
        guard let userData = UserData.fetchBy(userId: userResponse.userId) else {
            print("\(logTag) no userdata found for \(userResponse), create one first")
            return
        }
        
        context.perform {
            var contactsUserData: [UserData] = []
            contacts.forEach { contact in
                if let newContactUser = UserData.updateUserData(from: contact, instantSave: false) {
                    contactsUserData.append(newContactUser)
                }
            }
            userData.contacts = NSSet(array: contactsUserData)
            
            do {
                try context.save()
            } catch {
                fatalError("\(logTag) failed to save update contacts")
            }
        }
        
    }

    func contactsArray() -> [User] {
        var contactsArray: [User] = []
        contacts?.forEach { contact in
            contactsArray.append(contact as! User)
        }
        return contactsArray
    }
}


