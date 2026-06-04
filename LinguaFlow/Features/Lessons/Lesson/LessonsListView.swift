//
//  LessonsListView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import SwiftUI

struct LessonsListView: View {
    
    let level: Level
    
    var lessons: [Lesson] { level.lessons }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(lessons) { lesson in
                    NavigationLink(
                        destination: LessonPlayerScreen(
                            level: level,
                            lesson: lesson
                        )
                    ) {
                        LessonRowView(
                            lesson: lesson,
                            accentColor: level.color
                        )
                    }
                    .buttonStyle(.plain)
                    
                    Divider()
                        .padding(.leading, 76)
                }
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(16)
        }
        .navigationTitle(level.title)
        .background(Color(.systemGroupedBackground))
    }
}
