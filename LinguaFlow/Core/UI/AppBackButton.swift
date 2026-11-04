//
//  AppBackButton.swift
//  LinguaFlow
//
//  Created by Кирилл on 03.11.2026.
//

import SwiftUI

private struct AppBackButton: ViewModifier {
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
                    .accessibilityLabel("Назад")
                }
            }
    }
}

extension View {
    func appBackButton() -> some View { modifier(AppBackButton()) }
}
