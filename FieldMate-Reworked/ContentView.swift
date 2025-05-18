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
    @State private var showPicker = false
    @State private var showNotificationView = false
    
    //    @State private var didAddSampleTasks = false
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading){
                WeekSlider(selectedDate: $selectedDate)
                DayTasks(selectedDate: selectedDate)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.top, 90)
            .padding(.horizontal, 10)
            .border(Color.gray, width: 1)
            
            if showNotificationView {
                Color.clear
                    .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterial)))
                    .opacity(0.9)
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.3), value: showNotificationView)
            }
            
            VStack (alignment: .trailing, spacing: 0){
                HStack {
                    Spacer()
                    NotificationButton {
                        showNotificationView.toggle()
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 75)
                }
                if showNotificationView {
                    NotificationPopover()
                        .padding(.top, 25)
                }
                Spacer()
            }
            .animation(.easeInOut(duration: 0.3), value: showNotificationView)
            
            VStack (alignment: .center, spacing: 0){
                Spacer()
                HStack {
                    Spacer()
                    SyncButton(action: sync)
                    .padding(.trailing, 20)
                    .padding(.bottom, 50)
                }
            }
            
        }
        .ignoresSafeArea(.all)
        .onAppear {
            // if !didAddSampleTasks {
            
            // poof delete all tasks lol
            let fetchDescriptor = FetchDescriptor<TaskEvent>()
            
            if let allTasks = try? modelContext.fetch(fetchDescriptor) {
                for task in allTasks {
                    modelContext.delete(task)
                }
            }
            
            // sample tasks here
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            
            let sampleTasks = [
                TaskEvent(title: "Penggantian Lampu", location: "Apple Developer Academy", date: formatter.date(from: "2025/05/19 08:00")!),
                TaskEvent(title: "Preventif AC", location: "Purwadhika School", date: formatter.date(from: "2025/05/19 09:00")!),
                TaskEvent(title: "Preventif Lift", location: "Lift Basement GOP 9", date: formatter.date(from: "2025/05/19 11:00")!),
                TaskEvent(title: "Pintu Utama Rusak", location: "Apple Developer Academy", date: formatter.date(from: "2025/05/19 13:00")!),
                TaskEvent(title: "Kendala Plumbing", location: "Toilet Lobby GOP 9", date: formatter.date(from: "2025/05/16 15:00")!),
                TaskEvent(title: "Pintu Utama Rusak", location: "Apple Developer Academy", date: formatter.date(from: "2025/05/20 13:00")!),
                TaskEvent(title: "Kendala Plumbing", location: "Toilet Lobby GOP 9", date: formatter.date(from: "2025/05/18 15:00")!),
                TaskEvent(title: "Penggantian Lampu", location: "Apple Developer Academy", date: formatter.date(from: "2025/05/21 17:00")!)
            ]
            
            for task in sampleTasks {
                modelContext.insert(task)
            }
            // didAddSampleTasks = true
            // }
        }
    }
}

struct SyncButton : View{
    let action: () -> Void
    var body: some View{
        Button(action: action){
            ZStack(alignment: .center){
                Circle()
                    .fill(Color(red: 0.18, green: 0.35, blue: 0.6))
                    .frame(width: 44, height: 44)
                Image(systemName: "arrow.clockwise")      .foregroundStyle(Color.white)
                    .font(.title2)
            }
                .shadow(color: .black.opacity(0.05), radius: 2.65, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


private func sync() {
    Task {
        do {
            try await importTasks(
                for: "Alex", // replace with desired engineer name or parameterize
                spreadsheetId: GoogleSheetsConfig.spreadsheetId,
                sheetName:     GoogleSheetsConfig.sheetName,
                apiKey:        GoogleSheetsConfig.apiKey
            )
        } catch {
            print("Import failed:", error)
        }
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: effect)
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}

#Preview {
    ContentView()
}
