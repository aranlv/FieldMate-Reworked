//
//  CalendarView.swift
//  FieldMate
//
//  Created by Aretha Natalova Wahyudi on 18/05/25.
//

import SwiftUI
import UIKit
import SwiftData

struct CalendarView: View {
    @AppStorage("lastSeenLogTime") private var lastSeenLogTime: Date = .distantPast
    @Query(sort: \ChangeLog.timestamp, order: .reverse) private var logs: [ChangeLog]
    @AppStorage("engineerName") private var engineerName: String = ""
    @Binding var selectedDate: Date
    @Binding var showNotificationView: Bool
    @State private var showNoNameAlert = false
    @Environment(\.modelContext) private var modelContext
    
    private var hasUnreadLogs: Bool {
            logs.contains { $0.timestamp > lastSeenLogTime }
        }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
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
            
            VStack(alignment: .trailing, spacing: 0){
                HStack {
                    Spacer()
                    NotificationButton(
                        action: {
                            // mark as read when opening
                            lastSeenLogTime = Date()
                            showNotificationView.toggle()
                        },
                        hasUnread: hasUnreadLogs
                    )
                    .padding(.trailing, 20)
                    .padding(.top, 75)
                }
                
                Spacer()
            }
            .animation(.easeInOut(duration: 0.3), value: showNotificationView)
            
            VStack(alignment: .center, spacing: 0){
                Spacer()
                HStack {
                    Spacer()
                    SyncButton(action: {
                        if engineerName.isEmpty {
                            showNoNameAlert = true
                        } else {
                            sync()
                        }
                    })
//                    .disabled(engineerName.isEmpty)
                    .opacity(engineerName.isEmpty ? 0.5 : 1)
                    .padding(.trailing, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .ignoresSafeArea(.all)
        .alert("No Engineer Name", isPresented: $showNoNameAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please set your engineer name on the Profile tab before syncing.")
        }
    }
    
    private func sync() {
        Task {
            do {
                try await importTasks(
                    for: engineerName,
                    spreadsheetId: GoogleSheetsConfig.spreadsheetId,
                    sheetName:     GoogleSheetsConfig.sheetName,
                    apiKey:        GoogleSheetsConfig.apiKey,
                    in: modelContext
                )
            } catch {
                print("Import failed:", error)
            }
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


#Preview {
    ContentView()
}
