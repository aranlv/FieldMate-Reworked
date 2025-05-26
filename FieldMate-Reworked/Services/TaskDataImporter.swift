//
//  TaskDataImporter.swift
//  FieldMate
//
//  Created by Aretha Natalova Wahyudi on 18/05/25.
//

import SwiftData
import Foundation

func importTasks(for engineerName: String,
                 spreadsheetId: String,
                 sheetName: String,
                 apiKey: String,
                 in context: ModelContext) async throws {
    
    let rows = try await fetchSheetRows(
        spreadsheetId: spreadsheetId,
        sheetName: sheetName,
        apiKey: apiKey
    )
    
    guard rows.count > 1 else { return }        // no data or only header
    
    let header = rows[0]
    let dataRows = rows.dropFirst()
    
    // Find the column indexes you need
    guard
        let idIdx         = header.firstIndex(of: "ID"),
        let titleIdx      = header.firstIndex(of: "Maintenance Task"),
        let dateIdx       = header.firstIndex(of: "Date"),
        let timeIdx       = header.firstIndex(of: "Time"),
        let locationIdx   = header.firstIndex(of: "Location"),
        let engineerIdx   = header.firstIndex(of: "Engineers")
    else {
        fatalError("Sheet is missing one of Maintenance Task/Date/Time/Location/Engineers columns")
    }
    
    // Filter rows by engineer (handles comma-separated names)
    let filtered = dataRows.filter { row in
        guard row.indices.contains(engineerIdx) else { return false }
        let cell = row[engineerIdx]
        return cell
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .contains(engineerName)
    }
    
    // Fetch existing TaskEvent objects and index by ID
    let existingTasks = try context.fetch(FetchDescriptor<TaskEvent>())
    let existingByID = Dictionary(uniqueKeysWithValues: existingTasks.map { ($0.id, $0) })
    
    // Track sheet IDs seen for deletion detection
    var sheetIDs = Set<String>()
    
    // Prepare date formatter
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    
    for row in filtered {
        let idValue = row[idIdx]
        sheetIDs.insert(idValue)
        
        let titleValue = row[titleIdx]
        let locationValue = row[locationIdx]
        let dateTimeString = "\(row[dateIdx]) \(row[timeIdx])"
        guard let dateValue = dateFormatter.date(from: dateTimeString) else { continue }
        
        if let existing = existingByID[idValue] {
            // Update if any field changed
            if existing.title != titleValue || existing.location != locationValue || existing.date != dateValue {
                existing.title = titleValue
                existing.location = locationValue
                existing.date = dateValue
                context.insert(ChangeLog(taskID: idValue,
                                         type: .updated,
                                         title: titleValue,
                                         location: locationValue,
                                         date: dateValue))
            }
        } else {
            // New task
            let newTask = TaskEvent(id: idValue,
                                    title: titleValue,
                                    location: locationValue,
                                    date: dateValue)
            context.insert(newTask)
            context.insert(ChangeLog(taskID: idValue,
                                     type: .added,
                                     title: titleValue,
                                     location: locationValue,
                                     date: dateValue))
        }
    }
    
    // Handle deleted tasks
    for task in existingTasks {
        if !sheetIDs.contains(task.id) {
            context.delete(task)
            context.insert(ChangeLog(taskID: task.id,
                                     type: .removed,
                                     title: task.title,
                                     location: task.location,
                                     date: task.date))
        }
    }
    
    // Persist everything
    try context.save()
}
