//
//  HomeView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.05.2026.
//

import SwiftUI

struct HomeView: View {
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                }
                .padding(20)
                .frame(maxWidth: 640)
                .frame(maxWidth: .infinity)
            }
            .background(Tab.home.color.opacity(0.09).ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }

    private var header: some View {
        HStack(spacing: 16) {
            TimelineView(.periodic(from: .now, by: 60)) { context in
                Text(greeting(at: context.date))
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 23, weight: .medium))
                    .foregroundStyle(.primary)
                    .frame(width: 48, height: 48)
                    .background(Color(.systemBackground), in: Circle())
            }
            .accessibilityLabel("Настройки")
        }
        .padding(.vertical, 8)
    }

    private func greeting(at date: Date) -> String {
        switch Calendar.current.component(.hour, from: date) {
        case 5..<12: return "Доброе утро ☀️"
        case 12..<18: return "Добрый день 🌤️"
        case 18..<23: return "Добрый вечер 🌙"
        default: return "Доброй ночи ✨"
        }
    }
}

#Preview {
    HomeView()
}
