//
//  SheetsResponse.swift
//  FieldMate
//
//  Created by Aretha Natalova Wahyudi on 18/05/25.
//

struct SheetsResponse: Codable {
  struct ValueRange: Codable {
    let values: [[String]]?
  }
  let valueRanges: [ValueRange]
}
