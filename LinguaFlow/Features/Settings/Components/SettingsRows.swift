//
//  SettingsRows.swift
//  LinguaFlow
//
//  Created by Кирилл on 03.06.2026.
//

import SwiftUI

// MARK: - SettingsToggleRow

struct SettingsToggleRow: View {
    let icon: String
    let label: String
    let color: Color
    @Binding var isOn: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            SettingsRowLabel(icon: icon, label: label, color: color)
                .layoutPriority(1)
            Spacer()
            Toggle("", isOn: $isOn)
                .tint(color)
                .fixedSize()
        }
        .padding(16)
    }
}

// MARK: - SettingsNavRow

struct SettingsNavRow: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                SettingsRowLabel(icon: icon, label: label, color: color)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary.opacity(0.5))
            }
            .padding(16)
        }
    }
}

// MARK: - SettingsInfoRow

struct SettingsInfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 15))
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
        }
        .padding(16)
    }
}

// MARK: - SettingsRowLabel

struct SettingsRowLabel: View {
    let icon: String
    let label: String
    let color: Color

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)
                .frame(width: 20)
            Text(label)
                .font(.system(size: 15))
                .foregroundColor(.primary)
        }
    }
}
