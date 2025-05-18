//
//  FieldMate_ReworkedApp.swift
//  FieldMate-Reworked
//
//  Created by Aretha Natalova Wahyudi on 09/05/25.
//

import SwiftUI
import AppIntents

@main
struct FieldMate_ReworkedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: TaskEvent.self)
    }
}

