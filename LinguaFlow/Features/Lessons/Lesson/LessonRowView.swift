//
//  LessonRowView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import SwiftUI

struct LessonRowView: View {
    
    let lesson: Lesson
    let accentColor: Color

    var body: some View {
        HStack(spacing: 16) {
            // Номер / статус
            ZStack {
                Circle()
                    .fill(
                        lesson.isCompleted ? accentColor :
                        lesson.isLocked ? Color(.systemGray5) :
                        accentColor.opacity(0.12)
                    )
                    .frame(width: 44, height: 44)

                if lesson.isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                } else if lesson.isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.systemGray3))
                } else {
                    Text("\(lesson.id)")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(accentColor)
                }
            }

            // Название и длительность
            VStack(alignment: .leading, spacing: 3) {
                Text(lesson.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(lesson.isLocked ? .secondary : .primary)

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    Text(lesson.duration)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            if !lesson.isLocked {
                Image(systemName: lesson.isCompleted ? "arrow.clockwise.circle.fill" : "play.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(lesson.isCompleted ? accentColor.opacity(0.6) : accentColor)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .opacity(lesson.isLocked ? 0.6 : 1.0)
    }
    
}
