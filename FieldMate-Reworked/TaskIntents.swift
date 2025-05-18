//
//  AppIntents.swift
//  FieldMate-Reworked
//
//  Created by Aretha Natalova Wahyudi on 16/05/25.
//

import AppIntents
import SwiftData

struct ShowTodayTasksIntent: AppIntent {
    static var title: LocalizedStringResource = "Show Today’s Tasks"

    static var description = IntentDescription("Shows tasks scheduled for today.")

    func perform() async throws -> some IntentResult {
        // Optionally: trigger a notification or update UI here
        return .result(dialog: "Showing your tasks for today in FieldMate.")
    }
}

struct TaskAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ShowTodayTasksIntent(),
            phrases: ["Show my tasks", "Show tasks for today in \(.applicationName)"],
            shortTitle: "Today’s Tasks",
            systemImageName: "checkmark.circle"
        )
    }
}
