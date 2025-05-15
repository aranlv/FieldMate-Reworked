//
//  WeekSlider.swift
//  FieldMate-Reworked
//
//  Created by Aretha Natalova Wahyudi on 12/05/25.
//

import SwiftUI

struct WeekSlider: View {
    @Binding var selectedDate: Date
    @State private var weekOffset = 0
    @State private var showMonthYearPicker = false
    
    private let calendar = Calendar.current
    private let weekCount = 301  // Total number of weeks to generate
    private let centerIndex = 150  // Middle week index (current week)
    
    // Calculate the start of the current week
    private var currentWeekStart: Date {
        calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
    
    // Get the date for a specific week offset
    private func getDateForWeek(_ offset: Int) -> Date {
        calendar.date(byAdding: .weekOfYear, value: offset, to: currentWeekStart)!
    }
    
    // Check if a date is in the currently displayed week
    private func isDateInDisplayedWeek(_ date: Date, for offset: Int) -> Bool {
        let displayedWeek = getDateForWeek(offset)
        return calendar.isDate(date, equalTo: displayedWeek, toGranularity: .weekOfYear)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // Main content
            VStack(spacing: 8) {
                HStack {
                    // Use a fixed size box to maintain consistent layout whether picker is shown or not
                    ZStack(alignment: .leading) {
                        // This invisible element maintains the space regardless of whether text is shown
                        Text(formatMonthYear(for: getDateForWeek(weekOffset)))
                            .font(.title2)
                            .fontWeight(.bold)
                            .opacity(0)
                        
                        // Only show the actual text when picker is not active
                        if !showMonthYearPicker {
                            HStack {
                                Text(formatMonthYear(for: getDateForWeek(weekOffset)))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Image(systemName: "chevron.right")
                                    .imageScale(.medium)
                                    .foregroundStyle(.black)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    showMonthYearPicker = true
                                }
                            }
                        }
                        else {
                            ZStack (alignment: .leading) {
                                Color.clear
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation {
                                            showMonthYearPicker = false
                                        }
                                    }
                                VStack(alignment: .leading) {
                                    monthYearPicker
                                    Spacer()
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // "This Week" button
                    if !showMonthYearPicker {
                        Button(action: {
                            withAnimation {
                                weekOffset = 0
                                selectedDate = Date()
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 12))
                                Text("This Week")
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .opacity(isDateInDisplayedWeek(Date(), for: weekOffset) ? 0 : 1)
                        .animation(.easeInOut(duration: 0.3), value: isDateInDisplayedWeek(Date(), for: weekOffset))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                // TabView showing weeks
                TabView(selection: $weekOffset) {
                    ForEach(-centerIndex..<centerIndex, id: \.self) { offset in
                        WeekRowView(
                            baseDate: getDateForWeek(offset),
                            selectedDate: $selectedDate
                        )
                        .padding(.horizontal, 4)
                        .tag(offset)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 100)
            }
            
            // Full screen transparent overlay to detect outside taps when picker is shown
//            if showMonthYearPicker {
//                Color.clear
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        withAnimation {
//                            showMonthYearPicker = false
//                        }
//                    }
//                    .edgesIgnoringSafeArea(.all)
//                    .border(Color.gray)
//            }
//            
//            // Picker overlay
//            if showMonthYearPicker {
//                VStack(alignment: .leading) {
//                    monthYearPicker
//                        .padding(.horizontal)
//                    Spacer()
//                }
//                .padding(.top)
//                .border(Color.gray)
//            }
        }
        .onChange(of: selectedDate) { _, newDate in
            // When selected date changes, update the week offset if needed
            let startOfNewDateWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: newDate))!
            
            if startOfNewDateWeek != getDateForWeek(weekOffset) {
                let newOffset = calendar.dateComponents([.weekOfYear], from: currentWeekStart, to: startOfNewDateWeek).weekOfYear ?? 0
                
                withAnimation {
                    weekOffset = newOffset
                }
            }
        }
        .onChange(of: weekOffset) { _, _ in
            // Hide picker when swiping between weeks
            if showMonthYearPicker {
                withAnimation {
                    showMonthYearPicker = false
                }
            }
        }
    }
    
    private var monthYearPicker: some View {
        let currentMonthYearDate = getDateForWeek(weekOffset)
        
        return HStack(spacing: 0) {
            Picker(selection: Binding(
                get: { Calendar.current.component(.month, from: currentMonthYearDate) },
                set: { updateWeekOffsetForMonthYear(month: $0, year: Calendar.current.component(.year, from: currentMonthYearDate)) }
            ), label: EmptyView()) {
                ForEach(1...12, id: \.self) { month in
                    Text(Calendar.current.monthSymbols[month - 1]).tag(month)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 150)

            Picker(selection: Binding(
                get: { Calendar.current.component(.year, from: currentMonthYearDate) },
                set: { updateWeekOffsetForMonthYear(month: Calendar.current.component(.month, from: currentMonthYearDate), year: $0) }
            ), label: EmptyView()) {
                ForEach(2020...2030, id: \.self) { year in
                    Text(String(format: "%d", year)).tag(year)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 100, height: 100)
        }
        .frame(height: 100)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
        .contentShape(Rectangle())
    }
    
    // Update week offset based on selected month and year
    private func updateWeekOffsetForMonthYear(month: Int, year: Int) {
        var components = DateComponents()
        components.day = 15  // Middle of the month to avoid edge cases
        components.month = month
        components.year = year
        
        if let newDate = calendar.date(from: components) {
            // Find the first day of the week containing this date
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: newDate))!
            
            // Calculate new week offset
            let newOffset = calendar.dateComponents([.weekOfYear], from: currentWeekStart, to: weekStart).weekOfYear ?? 0
            
            withAnimation {
                weekOffset = newOffset
                
                // Also update selected date to be in this week
                // We'll pick the same day of week as currently selected
                let currentDayOfWeek = calendar.component(.weekday, from: selectedDate)
                let targetDayOfWeek = calendar.component(.weekday, from: weekStart)
                let dayDifference = currentDayOfWeek - targetDayOfWeek
                selectedDate = calendar.date(byAdding: .day, value: dayDifference, to: weekStart) ?? weekStart
            }
        }
    }
    
    // Format month and year for display
    private func formatMonthYear(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct WeekRowView: View {
    let baseDate: Date
    @Binding var selectedDate: Date
    
    private let calendar = Calendar.current
    
    // Generate dates for the week starting from baseDate
    private var datesForWeek: [Date] {
        (0..<7).compactMap { index in
            calendar.date(byAdding: .day, value: index, to: baseDate)
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(datesForWeek, id: \.timeIntervalSince1970) { date in
                DayCard(
                    date: date,
                    isSelected: calendar.isDate(date, inSameDayAs: selectedDate)
                )
                .onTapGesture {
                    selectedDate = date
                }
            }
        }
    }
}

struct DayCard: View {
    let date: Date
    let isSelected: Bool

    @Environment(\.colorScheme) var colorScheme

    private let calendar = Calendar.current

    private var weekdayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }

    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    private var isToday: Bool {
        calendar.isDateInToday(date)
    }

    private var isWeekend: Bool {
        let weekday = calendar.component(.weekday, from: date)
        return weekday == 1 || weekday == 7
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(weekdayString)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)

            Text(dayString)
                .font(.title3)
                .fontWeight(isSelected ? .bold : .semibold)
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(
            isSelected ? Color.white : Color.gray )
        .padding(.vertical, 10)
        .background(
            ZStack {
                if isSelected {
                    Color(red: 0.18, green: 0.35, blue: 0.6)
                } else {
                    Color.clear
                }
            }
        )
        .cornerRadius(20)
    }
}

#Preview {
    ContentView()
}
