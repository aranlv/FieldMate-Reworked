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
    @State private var showNotificationView = false
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            TabView {
                // Calendar Tab
                CalendarView(selectedDate: $selectedDate, showNotificationView: $showNotificationView)
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
            
            if showNotificationView {
                NotificationPopover()
                    .padding(.top, 80)
            }
        }
    }
}

#Preview {
    ContentView()
}
