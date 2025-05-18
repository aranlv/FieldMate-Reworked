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
                 apiKey: String) async throws {
  
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

  // Get a SwiftData context
  let context = ModelContext(TaskEvent.modelContainer)

  for row in filtered {
    // Parse date and time (adjust your formatter to match the sheet’s format)
    let dateString = row[dateIdx]
    let timeString = row[timeIdx]
    let dateTimeString = "\(dateString) \(timeString)"
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    guard let date = formatter.date(from: dateTimeString) else { continue }

    // Extract location
    let locationString = row[locationIdx]

    // Build your model object
    let task = TaskEvent(
      id: UUID(),
      title: row[titleIdx],
      location: locationString,
      date: date
    )

    context.insert(task)
  }

  // Persist everything
  try context.save()
}
