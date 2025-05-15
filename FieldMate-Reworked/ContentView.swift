//
//  ContentView.swift
//  FieldMate-Reworked
//
//  Created by Aretha Natalova Wahyudi on 09/05/25.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var selectedDate = Date()
    @State private var showPicker = false
    @State private var showNotificationView = false
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading){
                WeekSlider(selectedDate: $selectedDate)
                DayTasks()
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
        }
        .ignoresSafeArea(.all)
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
