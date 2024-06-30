//
//  MarkStreamApp.swift
//  MarkStream
//
//  Created by Ghazanfar Shahbaz on 6/29/24.
//

import SwiftUI

@main
struct MarkStreamApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
