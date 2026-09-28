//
//  LinguaFlowApp.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import SwiftUI
import CoreData

@main
struct LinguaFlowApp: App {

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext,
                              persistenceController.container.viewContext)
                .onAppear {
                    ProgressManager.shared.setContext(
                        persistenceController.container.viewContext
                    )
                    FlashcardStore.shared.setContext(
                        persistenceController.container.viewContext
                    )
                }
        }
    }
    
}
