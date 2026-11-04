//
//  LevelsTabView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import SwiftUI

struct LevelsTabView: View {
    
    let levels: [Level] = [
        LevelLoader.load(level: 1),
        LevelLoader.load(level: 2),
        LevelLoader.load(level: 3)
    ].compactMap { $0 }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(levels) { level in
                            NavigationLink(destination: LessonsListView(level: level)) {
                                LevelsView(level: level)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(16)
                }
                .background(Color(.systemGroupedBackground))
                .scrollContentBackground(.hidden)
                .toolbar(.hidden, for: .navigationBar)
                .safeAreaInset(edge: .top, spacing: 0) {
                    AppTabHeader("Уроки")
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        .padding(.bottom, 12)
                        .background(Color(.systemGroupedBackground))
                }
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
    
}
