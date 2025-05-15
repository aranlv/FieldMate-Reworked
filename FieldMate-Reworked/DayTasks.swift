//
//  DayTasks.swift
//  FieldMate-Reworked
//
//  Created by Aretha Natalova Wahyudi on 15/05/25.
//

import SwiftUI

struct DayTasks: View {
    let taskList: [TaskEvent] = [
        .init(title: "Preventif AC", location: "Apple Developer Academy", time: "9:00", isActive: true),
        .init(title: "Preventif Lift", location: "Apple Developer Academy", time: "11:00", isActive: false),
        .init(title: "Pintu Utama Rusak", location: "Apple Developer Academy", time: "13:00", isActive: false),
        .init(title: "Flush Toilet Rusak", location: "Apple Developer Academy", time: "15:00", isActive: false),
        .init(title: "Penggantian Lampu", location: "Apple Developer Academy", time: "17:00", isActive: false),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(taskList.indices, id: \.self) { index in
                HStack(alignment: .top, spacing: 15) {
                    VStack {
                        TimelineIndicator(
                            isActive: taskList[index].isActive,
                            showLine: index != taskList.count - 1
                        )
                    }
                    TaskCard(event: taskList[index],
                             isActive: taskList[index].isActive)
                }
            }
        }
        .padding()
        .background(Color.white)
    }
}

struct TaskCard: View {
    let event: TaskEvent
    let isActive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(event.title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(event.isActive ? .white : .black)
                Spacer()
                Text(event.time)
                    .foregroundColor(event.isActive ? .white : .gray)
            }
            Text(event.location)
                .foregroundColor(event.isActive ? .white.opacity(0.8) : .gray)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, isActive ? 20 : 0)
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if event.isActive {
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
                    .frame(width: 2, height: isActive ? 100 : 80)
            }
        }
        .frame(width: 20)
    }
}

#Preview {
    DayTasks()
}
