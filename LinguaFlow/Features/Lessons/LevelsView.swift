//
//  LevelsView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import SwiftUI

struct LevelsView: View {
    
    let level: Level
    @State private var isPressed = false
 
    var body: some View {
        HStack(spacing: 20) {
            // Icon
            ZStack {
                Circle()
                    .fill(level.color.opacity(0.15))
                    .frame(width: 64, height: 64)
 
                Text(level.icon)
                    .font(.system(size: 30))
            }
 
            // Text info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(level.title)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
 
                    Text(level.subtitle)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(level.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(level.color.opacity(0.12))
                        .clipShape(Capsule())
                }
 
                Text(level.description)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(4)
 
                HStack(spacing: 4) {
                    Image(systemName: "headphones")
                        .font(.system(size: 11))
                        .foregroundColor(level.color)
                    Text("\(level.lessons.count) уроков")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(level.color)
                }
                .padding(.top, 2)
            }
 
            Spacer()
 
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary.opacity(0.5))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: level.color.opacity(0.15), radius: 12, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(level.color.opacity(0.2), lineWidth: 1)
        )
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
    
}
