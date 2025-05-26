//
//  SheetsAPIService.swift
//  FieldMate
//
//  Created by Aretha Natalova Wahyudi on 18/05/25.
//

import SwiftUI

enum GoogleSheetsConfig {
    static let spreadsheetId = "1JymtwZrwy1D5E9hCe0lRtyX0t6XYvO7AXuT2NmOHAv0"
    static let sheetName     = "Maintenance_Schedule"
    static let apiKey        = "AIzaSyAXxGZ3qIAkHGp31hG3a5wGM_N4pA0yM_M"
}

func fetchSheetRows(spreadsheetId: String,
                    sheetName: String,
                    apiKey: String) async throws -> [[String]] {
    
    let range = "\(sheetName)!A:Z"
    var components = URLComponents(string:
                                    "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetId)/values:batchGet"
    )!
    components.queryItems = [
        URLQueryItem(name: "ranges", value: range),
        URLQueryItem(name: "majorDimension", value: "ROWS"),
        URLQueryItem(name: "key", value: apiKey),
    ]
    let (data, response) = try await URLSession.shared.data(from: components.url!)
    
    if let http = response as? HTTPURLResponse,
           !(200...299).contains(http.statusCode) {
          // Log status + body
          let bodyText = String(data: data, encoding: .utf8) ?? "<binary data>"
          print("⚠️ Sheets API returned HTTP \(http.statusCode):\n\(bodyText)")
          throw URLError(.badServerResponse)
        }
    
    if let jsonString = String(data: data, encoding: .utf8) {
          print("📥 Raw Sheets JSON:\n\(jsonString)")
        } else {
          print("📥 Raw Sheets response was not valid UTF-8")
        }
    
    let sheet = try JSONDecoder().decode(SheetsResponse.self, from: data)
    return sheet.valueRanges.first?.values ?? []
}
