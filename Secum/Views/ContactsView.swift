//
//  ContactsView.swift
//  Secum
//
//  Created by Chen Cen on 10/20/23.
//

import Foundation
import SwiftUI
import CoreData

struct ContactsView: View {
    let owner: User
    @FetchRequest var contacts: FetchedResults<UserData>
    
    @State private var shouldShowTabBar = true
    
    init(owner: User) {
        self.owner = owner
        self._contacts = FetchRequest(fetchRequest: UserData.contactsRequest(owner: owner))
    }
    
    var body: some View {
        NavigationView {
            List(contacts) { contact in
                NavigationLink(destination: ConversationView(owner: owner, peerId: contact.userId!, shouldShowTabBar: $shouldShowTabBar)) {
                    HStack{
                        Image("botIcon")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding()

//                        Text(contact.nickname.nickNameToBotName())
                        Text(contact.nickname!)
                    }
                }
            }
        }.toolbar(shouldShowTabBar ? .visible : .hidden, for: .tabBar)
    }
}

/// Doesn't work
struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        // 1. Create a sample managed object context
        let previewContext = PersistenceController.preview.container.viewContext
        
        // 2. Insert some sample UserData objects
        let sampleUser = User(userId: "1", nickname: "Tora")
        let _ = UserData.updateUserData(
            from:sampleUser,
            context: previewContext
        )
        
        UserData.updateContacts(
            for: sampleUser,
            contacts: [
                .init(userId: "2", nickname: "Tora's contact1"),
                .init(userId: "3", nickname: "Tora's contact2"),
            ],
            context: previewContext)
        
        do {
            try previewContext.save()
        } catch {}
        
        // 3. Initialize your view with the sample data
        return ContactsView(owner: sampleUser)
            .environment(\.managedObjectContext, previewContext)
            .previewDisplayName("Contacts View")
        
    }
}
