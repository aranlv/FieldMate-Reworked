//
//  DayTasks.swift
//  FieldMate-Reworked
//
//  Created by Aretha Natalova Wahyudi on 15/05/25.
//

import SwiftUI
import SwiftData

struct DayTasks: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var taskList: [TaskEvent]
    
    let selectedDate: Date
    
    var filteredTasks: [TaskEvent] {
        let calendar = Calendar.current
        return taskList
            .filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
            .sorted { $0.date < $1.date }
    }
    
    var activeTaskID: String? {
        let now = Date()
        let tasksToday = taskList.filter {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
        
        let sortedTasks = tasksToday.sorted { $0.date < $1.date }
        
        for i in 0..<sortedTasks.count {
            let current = sortedTasks[i].date
            let next = i + 1 < sortedTasks.count ? sortedTasks[i + 1].date : nil
            
            if now >= current && (next == nil || now < next!) {
                return sortedTasks[i].id
            }
        }
        return nil
    }
    
    var body: some View {
        if filteredTasks.isEmpty {
            GeometryReader { geo in
                VStack(alignment: .center){
                    Text("No tasks for this day.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(width: geo.size.width, height: geo.size.height - 150)
            }
        }
        else {
            GeometryReader { geo in
                ScrollViewReader { proxy in
                    ZStack {
                        ScrollView {
                            VStack (alignment: .leading, spacing: 6) {
                                ForEach(filteredTasks, id: \.id) { task in
                                    HStack(alignment: .top, spacing: 15) {
                                        VStack {
                                            TimelineIndicator(
                                                isActive: task.id == activeTaskID,
                                                showLine: task.id != filteredTasks.last?.id
                                            )
                                        }
                                        TaskCard(event: task,
                                                 isActive: task.id == activeTaskID)
                                    }
                                    .id(task.id) // 👈 make each row identifiable
                                }
                            }
                            .padding()
                            .frame(height: geo.size.height + CGFloat((filteredTasks.count - 1) * 100), alignment: .top)
                            .frame(maxHeight: .infinity, alignment: .top)
//                            .border(Color.gray, width: 0.5)
                        }
//                        .mask(
//                            LinearGradient(
//                                gradient: Gradient(stops: [
//                                    .init(color: .black.opacity(0), location: 0),
//                                    .init(color: .black, location: 0.03),
//                                    .init(color: .black, location: 0.97),
//                                    .init(color: .black.opacity(0), location: 1)
//                                ]),
//                                startPoint: .top,
//                                endPoint: .bottom
//                            )
//                        )
                    }
                    .task(id: activeTaskID) {
                        if let activeID = activeTaskID {
                            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                            withAnimation {
                                proxy.scrollTo(activeID, anchor: .top)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct TaskCard: View {
    let event: TaskEvent
    let isActive: Bool
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: event.date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(event.title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(isActive ? .white : .black)
                Spacer()
                Text(timeString)
                    .foregroundColor(isActive ? .white : .gray)
            }
            Text(event.location)
                .foregroundColor(isActive ? .white.opacity(0.8) : .gray)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, isActive ? 20 : 0)
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if isActive {
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.21, green: 0.38, blue: 0.62), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.01, green: 0.21, blue: 0.48), location: 0.47),
                            Gradient.Stop(color: Color(red: 0, green: 0.12, blue: 0.32), location: 0.98),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 0.95)
                    )
                } else {
                    Color.clear
                }
            }
        )
        .cornerRadius(24)
    }
}

struct TimelineIndicator: View {
    let isActive: Bool
    let showLine: Bool
    
    var body: some View {
        VStack {
            if isActive {
                Circle()
                    .strokeBorder(Color.black, lineWidth: 1)
                    .background(
                        Circle()
                            .fill(Color.black)
                            .padding(2)
                    )
                    .frame(width: 20, height: 20)
            } else {
                Circle()
                    .strokeBorder(Color.black, lineWidth: 1)
                    .frame(width: 12, height: 12)
            }
            
            if showLine {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 2, height: isActive ? 100 : 70)
            }
        }
        .frame(width: 20)
    }
}

#Preview {
    DayTasks(selectedDate: Date())
}
