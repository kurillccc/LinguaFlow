//
//  SettingsButtons.swift
//  LinguaFlow
//
//  Created by Кирилл on 03.06.2026.
//

import SwiftUI

// MARK: - ThemeButton

struct ThemeButton: View {
    let label: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(label)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color(red: 0.72, green: 0.37, blue: 0.95) : Color(.systemGray6))
            )
        }
    }
}

// MARK: - TextSizeButton

struct TextSizeButton: View {
    let label: String
    let size: String
    @Binding var selected: String

    var isSelected: Bool { selected == size }

    var body: some View {
        Button { selected = size } label: {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color(red: 0.72, green: 0.37, blue: 0.95) : Color(.systemGray6))
                )
        }
    }
}
