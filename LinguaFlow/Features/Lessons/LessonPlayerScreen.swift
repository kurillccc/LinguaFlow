//
//  LessonPlayerScreen.swift
//  LinguaFlow
//
//  Created by Кирилл on 04.06.2026.
//

import SwiftUI

struct LessonPlayerScreen: View {
    
    let level: Level
    
    @State private var currentLesson: Lesson
    @State private var lastPosition: Double = 0
    
    init(level: Level, lesson: Lesson) {
        self.level = level
        _currentLesson = State(initialValue: lesson)
    }
    
    var body: some View {
        LessonView(
            lesson: currentLesson,
            level: level
        ) { nextLesson in
            withAnimation(.easeInOut(duration: 0.2)) {
                currentLesson = nextLesson
            }
        }
        .onAppear {
            loadProgress()
        }
    }
    
    private func loadProgress() {
        let progress = ProgressManager.shared.load(lessonId: currentLesson.id)
        lastPosition = progress?.lastPosition ?? 0
    }
    
}
