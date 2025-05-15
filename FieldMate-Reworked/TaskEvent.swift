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
    var time: String
    var isActive: Bool
    
    init(id: UUID = UUID(), title: String, location: String, time: String, isActive: Bool) {
        self.id = id
        self.title = title
        self.location = location
        self.time = time
        self.isActive = isActive
    }
}
