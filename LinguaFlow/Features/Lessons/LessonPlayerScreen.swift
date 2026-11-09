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
    }
}
