//
//  LessonView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import SwiftUI

struct LessonView: View {
    
    let lesson: Lesson
    let level: Level
 
    @StateObject private var audio = AudioPlayerManager()
    @Environment(\.dismiss) private var dismiss
    @State private var textScale: CGFloat = 1.0
 
    var body: some View {
        VStack(spacing: 0) {
 
            // MARK: — Navigation header
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(level.color)
                        .frame(width: 36, height: 36)
                        .background(level.color.opacity(0.1))
                        .clipShape(Circle())
                }
 
                Spacer()
 
                VStack(spacing: 2) {
                    Text(level.icon + " " + level.title)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    Text("Урок \(lesson.id)")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                }
 
                Spacer()
 
                // Размер текста
                Menu {
                    Button("Мелкий") { textScale = 0.85 }
                    Button("Обычный") { textScale = 1.0 }
                    Button("Крупный") { textScale = 1.2 }
                } label: {
                    Image(systemName: "textformat.size")
                        .font(.system(size: 17))
                        .foregroundColor(level.color)
                        .frame(width: 36, height: 36)
                        .background(level.color.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
 
            Divider()
 
            // MARK: — Текст урока
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(lesson.title)
                        .font(.system(size: 22 * textScale, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
 
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        Text(lesson.duration)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                        Text("·")
                            .foregroundColor(.secondary)
                        Image(systemName: "headphones")
                            .font(.system(size: 12))
                            .foregroundColor(level.color)
                        Text("Аудио + текст")
                            .font(.system(size: 13))
                            .foregroundColor(level.color)
                    }
 
                    Divider()
 
                    Text((try? AttributedString(markdown: lesson.text)) ?? AttributedString(lesson.text))
                        .font(.system(size: 16 * textScale))
                        .foregroundColor(.primary.opacity(0.85))
                        .lineSpacing(6)
                }
                .padding(20)
                .padding(.bottom, 8)
            }
 
            // MARK: — Аудио плеер
            AudioPlayerView(audio: audio, level: level)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true)
        .onAppear {
            audio.load(lessonId: lesson.id, levelId: lesson.levelId)
        }
    }
    
}
