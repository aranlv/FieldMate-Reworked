//
//  AppIntents.swift
//  FieldMate-Reworked
//
//  Created by Aretha Natalova Wahyudi on 16/05/25.
//

import AppIntents
import SwiftData

// Shared container for AppIntents
private let sharedModelContainer: ModelContainer = {
    try! ModelContainer(for: TaskEvent.self, ChangeLog.self)
}()

struct GetCurrentTask: AppIntent {
    static var title: LocalizedStringResource = "Get Current Task"
    static var description = IntentDescription("Provides complete details of currently scheduled task")
    static var providesDialog: Bool = true

    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView{
        let context = ModelContext(sharedModelContainer)
        let calendar = Calendar.current
        let now = Date()

        // Calculate the start and end of today for predicate filtering
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        // Attempt to fetch only today's tasks using a date-range predicate
        let fetchDescriptor = FetchDescriptor<TaskEvent>(
            predicate: #Predicate { task in
                task.date >= startOfDay && task.date < endOfDay
            }
        )

        let tasksToday: [TaskEvent]
        do {
            tasksToday = try context.fetch(fetchDescriptor)
                .sorted { $0.date < $1.date }
        } catch {
            // If SwiftData fetch fails, report it
            return .result(
                dialog: "Sorry, I couldn’t load your tasks: \(error.localizedDescription)"
            )
        }

        guard !tasksToday.isEmpty else {
            return .result(dialog: "You have no tasks scheduled for today.")
        }

        // Find the active task based on current time
        if let active = tasksToday.enumerated().first(where: { idx, task in
            let start = task.date
            let end = (idx + 1 < tasksToday.count) ? tasksToday[idx + 1].date : nil
            return now >= start && (end == nil || now < end!)
        })?.element {
            let timeString = DateFormatter.localizedString(
                from: active.date,
                dateStyle: .none,
                timeStyle: .short
            )
            let dialog = IntentDialog(
                full: "Your current task is \(active.title) at \(timeString).",
                supporting: "\(active.title) at \(timeString) is your active task."
            )
            let snippet = TaskCard(event: active, isActive: true)
            return .result(dialog: dialog, view: snippet)
        }

        // If no task has yet started or all are in the past
        return .result(dialog: "You don’t have an active task at the moment.")
    }
}

struct TaskAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: GetCurrentTask(),
            phrases: ["What is my task right now in \(.applicationName)"],
            shortTitle: "Current Task",
            systemImageName: "checkmark.circle"
        )
    }
}
