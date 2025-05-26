//
//  NotificationButton.swift
//  FieldMate-Reworked
//
//  Created by Aretha Natalova Wahyudi on 15/05/25.
//

import SwiftUI
import SwiftData

struct NotificationButton : View{
    let action: () -> Void
    let hasUnread: Bool
    
    var body: some View{
        ZStack {
            Button(action: action){
                ZStack(alignment: .center){
                    Circle()
                        .fill(Color(red: 0.18, green: 0.35, blue: 0.6))
                        .frame(width: 44, height: 44)
                    Image(systemName: "bell.fill")
                        .foregroundStyle(Color.white)
                        .font(.title2)
                }
                .shadow(color: .black.opacity(0.05), radius: 2.65, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
            
            if hasUnread {
                Circle()
                    .fill(Color.red)
                    .frame(width: 10, height: 10)
                    .offset(x: 6, y: -6)
            }
        }
    }
}

struct NotificationPopover: View {
    @Query(sort: \ChangeLog.timestamp, order: .reverse) private var logs: [ChangeLog]
    
    var body: some View {
        VStack(spacing: 12) {
            if logs.isEmpty {
                Text("No notifications yet")
                    .font(.headline)
                    .foregroundColor(.secondary)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(logs, id: \.id) { log in
                            NotificationCard(status: log.type.rawValue, loc: log.location, title: log.title, date: log.timestamp)
                        }
                    }
                    .padding()
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            PopoverShape()
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 0)
        )
        .ignoresSafeArea(edges: .bottom)
    }
}

struct PopoverShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornerRadius: CGFloat = 20
        let pointerSize: CGFloat = 15
        let pointerPositionX = rect.maxX - 42 // Adjust pointer horizontal position
        
        // Start top-left corner
        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
        
        // Top edge to just before pointer
        path.addLine(to: CGPoint(x: pointerPositionX - pointerSize, y: rect.minY))
        
        // Pointer (triangle)
        path.addLine(to: CGPoint(x: pointerPositionX, y: rect.minY - pointerSize))
        path.addLine(to: CGPoint(x: pointerPositionX + pointerSize, y: rect.minY))
        
        // Continue top edge
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        
        // Top-right corner
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)
        
        // Right edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        
        // Bottom-right corner
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)
        
        // Bottom edge
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        
        // Bottom-left corner
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)
        
        // Left edge
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        
        // Top-left corner
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)
        
        return path
    }
}

struct NotificationCard: View {
    var status: String
    var loc: String
    var title: String
    var date: Date
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private var color: Color {
        switch status {
        case "added": return Color(red: 0.18, green: 0.35, blue: 0.6)
        case "updated": return Color(red: 0.25, green: 0.6, blue: 0)
        case "removed": return Color(red: 0.64, green: 0.153, blue: 0)
        default: return Color(red: 0.18, green: 0.35, blue: 0.6)
        }
    }
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            HStack(alignment: .center, spacing: 23) {
                Text(status)
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .foregroundStyle(Color(UIColor.systemBackground))
            .font(.caption)
            .background(color)
            .cornerRadius(4)
            HStack(alignment: .top, spacing: 10) {
                Text("\(dateString)\n\(timeString)")
                    .font(.caption)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(color)
                    .frame(width: 82, alignment: .topTrailing)
                VStack(alignment: .leading){
                    Text("\(title)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color.black)
                    Text("\(loc)")
                        .font(.caption)
                        .foregroundColor(Color.black)
                }
                .padding(.leading, 15)
                .overlay(
                    Rectangle()
                        .frame(width: 2)
                        .foregroundColor(color), alignment: .leading)
            }
        }
        .padding(12)
        .frame(width: 335, alignment: .leading)
        .background(color.opacity(0.25))
        .cornerRadius(15)
    }
}

#Preview {
    NotificationCard(status: "removed", loc: "Apple Developer Academy", title: "Preventif AC", date: Date())
}

//
//#Preview {
//    ContentView()
//}
