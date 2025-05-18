//
//  TaskEvent.swift
//  FieldMate-Reworked
//
//  Created by Aretha Natalova Wahyudi on 15/05/25.
//
import SwiftData
import Foundation

@Model
class TaskEvent {
    @Attribute(.unique) var id: UUID
    var title: String
    var location: String
    var date: Date
    
    init(id: UUID = UUID(), title: String, location: String, date: Date) {
        self.id = id
        self.title = title
        self.location = location
        self.date = date
    }
}

extension TaskEvent {
    static var modelContainer: ModelContainer = {
        try! ModelContainer(for: TaskEvent.self)
    }()
}
