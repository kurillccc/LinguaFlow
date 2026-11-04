//
//  AppBackButton.swift
//  LinguaFlow
//
//  Created by Кирилл on 03.11.2026.
//

import SwiftUI

private struct AppBackButton: ViewModifier {
    let color: Color?
    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .tint(color)
                    .accessibilityLabel("Назад")
                }
            }
    }
}

extension View {
    func appBackButton(color: Color? = nil) -> some View {
        modifier(AppBackButton(color: color))
    }
}
