//
//  MarkStreamApp.swift
//  MarkStream
//
//  Created by Ghazanfar Shahbaz on 6/29/24.
//

import SwiftUI
import KeychainSwift

@main
struct MarkStreamApp: App {
    let persistenceController = PersistenceController.shared
    @State private var isAuthenticated =  (KeychainManager.shared.value(forKey: KeychainKeys.username) != nil) && (KeychainManager.shared.value(forKey: KeychainKeys.password) != nil)
    

    var body: some Scene {
        WindowGroup {
            if (isAuthenticated){
                MainView()
            }
            else {
                LoginView(isAuthenticated: $isAuthenticated)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
