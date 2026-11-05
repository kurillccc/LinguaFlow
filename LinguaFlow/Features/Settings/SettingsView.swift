//
//  SettingsView.swift
//  LinguaFlow
//
//  Created by Кирилл on 29.05.2026.
//

import SwiftUI

struct SettingsView: View {

    // MARK: - State
    @AppStorage("selectedTheme")      private var selectedTheme: String = "system"
    @AppStorage("playbackSpeed")      private var playbackSpeed: Double = 1.0
    @AppStorage("autoPlayNext")       private var autoPlayNext: Bool = true
    @AppStorage("dailyReminderOn")    private var dailyReminderOn: Bool = false
    @AppStorage("reminderHour")       private var reminderHour: Int = 9
    @AppStorage("textSize")          private var textSize: String = "medium"

    @State private var showResetAlert = false
    let accentColor = Color(red: 0.72, green: 0.37, blue: 0.95)

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    HStack(spacing: 14) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 48, height: 48)
                            .background(
                                LinearGradient(
                                    colors: [accentColor, Color(red: 0.25, green: 0.56, blue: 0.87)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                in: RoundedRectangle(cornerRadius: 15, style: .continuous)
                            )
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Учись в своём ритме")
                                .font(.system(.headline, design: .rounded, weight: .bold))
                            Text("Настрой тему, аудио и напоминания")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(settingsCard)
                    .padding(.horizontal, 20)

                    // MARK: — Внешний вид
                    SettingsSection(title: "Внешний вид", icon: "paintbrush.fill", color: accentColor) {
                        VStack(spacing: 0) {
                            // Тема
                            VStack(alignment: .leading, spacing: 10) {
                                SettingsRowLabel(icon: "circle.lefthalf.filled", label: "Тема", color: accentColor)
                                HStack(spacing: 8) {
                                    ThemeButton(label: "Светлая", icon: "sun.max.fill",
                                                isSelected: selectedTheme == "light") {
                                        selectedTheme = "light"
                                    }
                                    ThemeButton(label: "Тёмная", icon: "moon.fill",
                                                isSelected: selectedTheme == "dark") {
                                        selectedTheme = "dark"
                                    }
                                    ThemeButton(label: "Авто", icon: "circle.lefthalf.filled",
                                                isSelected: selectedTheme == "system") {
                                        selectedTheme = "system"
                                    }
                                }
                            }
                            .padding(16)
                        }
                    }

                    // MARK: — Аудио
                    SettingsSection(title: "Аудио", icon: "headphones", color: Color(red: 0.25, green: 0.56, blue: 0.87)) {
                        VStack(spacing: 0) {
                            // Скорость по умолчанию
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    SettingsRowLabel(icon: "speedometer", label: "Скорость по умолчанию",
                                                     color: Color(red: 0.25, green: 0.56, blue: 0.87))
                                    Spacer()
                                    Text(speedLabel(playbackSpeed))
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color(red: 0.25, green: 0.56, blue: 0.87))
                                }
                                Slider(value: $playbackSpeed, in: 0.5...2.0, step: 0.25)
                                    .tint(Color(red: 0.25, green: 0.56, blue: 0.87))
                                HStack {
                                    Text("0.5x").font(.system(size: 11)).foregroundColor(.secondary)
                                    Spacer()
                                    Text("2.0x").font(.system(size: 11)).foregroundColor(.secondary)
                                }
                            }
                            .padding(16)

                            Divider().padding(.leading, 16)

                            SettingsToggleRow(
                                icon: "arrow.right.circle.fill",
                                label: "Авто-переход к следующему уроку",
                                color: Color(red: 0.25, green: 0.56, blue: 0.87),
                                isOn: $autoPlayNext
                            )

                            Divider().padding(.leading, 16)

                            VStack(alignment: .leading, spacing: 10) {
                                SettingsRowLabel(
                                    icon: "textformat.size",
                                    label: "Размер текста по умолчанию",
                                    color: Color(red: 0.25, green: 0.56, blue: 0.87)
                                )
                                HStack(spacing: 8) {
                                    TextSizeButton(label: "Мелкий", size: "small", selected: $textSize)
                                    TextSizeButton(label: "Обычный", size: "medium", selected: $textSize)
                                    TextSizeButton(label: "Крупный", size: "large", selected: $textSize)
                                }
                            }
                            .padding(16)
                        }
                    }

                    // MARK: — Уведомления
                    SettingsSection(title: "Уведомления", icon: "bell.fill", color: Color(red: 0.95, green: 0.55, blue: 0.25)) {
                        VStack(spacing: 0) {
                            SettingsToggleRow(
                                icon: "bell.badge.fill",
                                label: "Ежедневное напоминание",
                                color: Color(red: 0.95, green: 0.55, blue: 0.25),
                                isOn: $dailyReminderOn
                            )

                            if dailyReminderOn {
                                Divider().padding(.leading, 16)
                                HStack {
                                    SettingsRowLabel(
                                        icon: "clock.fill",
                                        label: "Время напоминания",
                                        color: Color(red: 0.95, green: 0.55, blue: 0.25)
                                    )
                                    Spacer()
                                    Stepper("\(reminderHour):00", value: $reminderHour, in: 6...23)
                                        .fixedSize()
                                }
                                .padding(16)
                            }
                        }
                    }

                    // MARK: — Прогресс
                    SettingsSection(title: "Прогресс", icon: "chart.bar.fill", color: Color(red: 0.27, green: 0.73, blue: 0.56)) {
                        VStack(spacing: 0) {
                            SettingsNavRow(
                                icon: "arrow.counterclockwise",
                                label: "Сбросить прогресс",
                                color: .red
                            ) {
                                showResetAlert = true
                            }
                        }
                    }

                    // MARK: — О приложении
                    SettingsSection(title: "О приложении", icon: "info.circle.fill", color: .secondary) {
                        VStack(spacing: 0) {
                            SettingsInfoRow(label: "Версия", value: "1.0.0")
                            Divider().padding(.leading, 16)
                            SettingsInfoRow(label: "Разработчик", value: "Кирилл")
                            Divider().padding(.leading, 16)
                            SettingsInfoRow(label: "Метод обучения", value: "Pimsleur")
                        }
                    }

                    Text("LinguaFlow · 2026")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .padding(.bottom, 20)
                }
                .padding(.top, 8)
            }
        }
        .appScreenTitle("Настройки")
        .appBackButton(color: accentColor)
        .toolbar(.visible, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .alert("Сбросить прогресс?", isPresented: $showResetAlert) {
            Button("Сбросить", role: .destructive) {
                resetProgress()
            }
            Button("Отмена", role: .cancel) {}
        } message: {
            Text("Весь прогресс по урокам и карточкам будет удалён. Это действие нельзя отменить.")
        }
    }

    // MARK: - Helpers

    private var settingsCard: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(.systemBackground))
            .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 3)
    }

    private func speedLabel(_ speed: Double) -> String {
        speed == speed.rounded() ? "\(Int(speed)).0x" : "\(speed)x"
    }

    private func resetProgress() {
        // TODO: очистить SwiftData / UserDefaults прогресс
        print("🔄 Прогресс сброшен")
    }
}

#Preview {
    NavigationStack { SettingsView() }
}
