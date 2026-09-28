//
//  FlashcardTileView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.09.2026.
//

import SwiftUI

struct FlashcardTileView: View {

    let card: Flashcard
    let accentColor: Color

    @State private var isFlipped = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground))
                .shadow(color: accentColor.opacity(0.12), radius: 8, x: 0, y: 3)

            VStack(spacing: 8) {
                Text(isFlipped ? card.translation : card.word)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                if let example = card.example, !isFlipped {
                    Text(example)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }

                statusBadge
            }
            .padding(16)
            .transition(.opacity)
            .id(isFlipped)
        }
        .frame(height: 130)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                isFlipped.toggle()
            }
        }
    }

    private var statusBadge: some View {
        Text(card.isLearned ? "Выучено" : "В процессе")
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(card.isLearned ? accentColor : .secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background((card.isLearned ? accentColor : Color.secondary).opacity(0.12))
            .clipShape(Capsule())
    }
}
