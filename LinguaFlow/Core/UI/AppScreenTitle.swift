//
//  AppScreenTitle.swift
//  LinguaFlow
//
//  Created by Кирилл on 03.11.2026.
//

import SwiftUI

private struct AppScreenTitle: ViewModifier {
    let title: String
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
    }
}

extension View {
    func appScreenTitle(_ title: String) -> some View {
        modifier(AppScreenTitle(title: title))
    }
}
