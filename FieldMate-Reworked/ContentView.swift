//
//  ContentView.swift
//  FieldMate-Reworked
//
//  Created by Aretha Natalova Wahyudi on 09/05/25.
//

import SwiftUI
import UIKit
import SwiftData

struct ContentView: View {
    @State private var selectedDate = Date()
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView {
            // Calendar Tab
            CalendarView(selectedDate: $selectedDate)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
            
            // Profile Tab
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
        .background(Color.clear)
        .onAppear {
            // poof delete all tasks lol
            let fetchDescriptor = FetchDescriptor<TaskEvent>()
            
            if let allTasks = try? modelContext.fetch(fetchDescriptor) {
                for task in allTasks {
                    modelContext.delete(task)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
