//
//  AddFlashcardView.swift
//  LinguaFlow
//
//  Created by Кирилл on 28.09.2026.
//

import SwiftUI

struct AddFlashcardView: View {

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var store = FlashcardStore.shared

    @State private var word = ""
    @State private var translation = ""
    @State private var example = ""

    private let accentColor = Tab.practice.color

    private var canSave: Bool {
        !word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !translation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Слово") {
                    TextField("Например: Hola", text: $word)
                        .autocorrectionDisabled()
                }
                Section("Перевод") {
                    TextField("Например: Привет", text: $translation)
                        .autocorrectionDisabled()
                }
                Section("Пример использования (необязательно)") {
                    TextField("Например: ¡Hola! ¿Cómo estás?", text: $example, axis: .vertical)
                        .lineLimit(2...4)
                }
                Section {
                    Button {
                        store.add(word: word, translation: translation, example: example.isEmpty ? nil : example)
                        dismiss()
                    } label: {
                        Text("Сохранить")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!canSave)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .navigationTitle("Новая карточка")
            .navigationBarTitleDisplayMode(.inline)

        }
        .tint(accentColor)
    }
}

#Preview {
    AddFlashcardView()
}
