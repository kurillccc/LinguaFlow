//
//  ContentView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    let level: Level

    var body: some View {
        NavigationView {
            LevelsView(level: level)
        }
    }
}
