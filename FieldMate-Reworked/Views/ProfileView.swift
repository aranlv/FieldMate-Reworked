//
//  ProfileView.swift
//  FieldMate
//
//  Created by Aretha Natalova Wahyudi on 19/05/25.
//

import SwiftUI
import UIKit

struct ProfileView: View {
    @AppStorage("engineerName") private var engineerName: String = ""
    @State private var draftName: String = ""
    @FocusState private var nameFieldFocused: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Engineer") {
                    TextField("Enter your name", text: $draftName)
                        .textFieldStyle(.roundedBorder)
                        .focused($nameFieldFocused)
                        .submitLabel(.done)
                        .onSubmit { save() }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Keyboard “Done” button
                ToolbarItem(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        nameFieldFocused = false
                    }
                }
                // Save button in nav bar
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                    .disabled({
                        let trimmed = draftName.trimmingCharacters(in: .whitespaces)
                        return trimmed.isEmpty || trimmed == engineerName
                    }())
                }
            }
            .onAppear {
                // Initialize draft from stored value
                draftName = engineerName
            }
        }
    }

    private func save() {
        let trimmed = draftName.trimmingCharacters(in: .whitespaces)
        engineerName = trimmed
    }
}
