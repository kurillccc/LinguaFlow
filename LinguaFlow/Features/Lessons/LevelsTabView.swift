//
//  LevelsTabView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import SwiftUI

struct LevelsTabView: View {
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Level.all) { level in
                        LevelsView(level: level)
                    }
                }
                .padding(20)
            }
            .navigationTitle("Уроки")
        }
    }
    
}
