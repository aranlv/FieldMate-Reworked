//
//  ChangeLog.swift
//  FieldMate
//
//  Created by Aretha Natalova Wahyudi on 19/05/25.
//

import SwiftData
import Foundation

@Model
class ChangeLog {
  @Attribute(.unique) var id: UUID = UUID()
  enum ChangeType: String, Codable {
    case added, updated, removed
  }
  var taskID: String            // the sheet’s row ID
  var type: ChangeType
  var timestamp: Date = Date()
  var title: String
  var location: String
  var date: Date
  
  init(taskID: String, type: ChangeType, title: String, location: String, date: Date) {
    self.taskID = taskID
    self.type = type
    self.title = title
    self.location = location
    self.date = date
  }
}
