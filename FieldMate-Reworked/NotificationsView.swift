//
//  NotificationButton.swift
//  FieldMate-Reworked
//
//  Created by Aretha Natalova Wahyudi on 15/05/25.
//

import SwiftUI

struct NotificationButton : View{
    let action: () -> Void
    var body: some View{
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
    }
}

struct NotificationPopover: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("No notifications yet")
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            PopoverShape()
                .fill(Color.white)
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

#Preview {
    ContentView()
}
