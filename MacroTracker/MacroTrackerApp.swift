//
//  MacroTrackerApp.swift
//  MacroTracker
//
//  Created by Ryan Soe on 2/16/25.
//

import SwiftUI

@main
struct MacroTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
