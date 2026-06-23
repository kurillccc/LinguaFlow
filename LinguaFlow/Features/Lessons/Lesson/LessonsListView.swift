//
//  LessonsListView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import SwiftUI
import Combine

struct LessonsListView: View {
    
    let level: Level
    @State private var progressCache: [String: LessonProgressEntity] = [:]
    
    var lessons: [Lesson] { level.lessons }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(lessons) { lesson in
                    let progress = progressCache["\(lesson.levelId)_\(lesson.id)"]
                    
                    NavigationLink(destination: LessonPlayerScreen(level: level, lesson: lesson)) {
                        LessonRowView(
                            lesson: lesson,
                            progress: progress?.toModel(),
                            accentColor: level.color
                        )
                    }
                    .buttonStyle(.plain)
                    
                    Divider().padding(.leading, 76)
                }
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(16)
        }
        .navigationTitle(level.title)
        .background(Color(.systemGroupedBackground))
        .onAppear {
            progressCache = ProgressManager.shared.progressCache
        }
    }
    
}
