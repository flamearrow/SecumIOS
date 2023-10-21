//
//  SecumApp.swift
//  Secum
//
//  Created by Chen Cen on 6/19/23.
//

import SwiftUI

@main
struct SecumApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment( // This would ensure @FetchRequest used within knows which context to search for
                    \.managedObjectContext,
                     PersistenceController.shared.container.viewContext
                )
        }
    }
}
