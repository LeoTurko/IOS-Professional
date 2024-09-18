//
//  Date+Utils.swift
//  Bankey
//
//  Created by Леонид Турко on 16.09.2024.
//

import Foundation

extension Date {
  static var bankeyDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "MDT")
    return formatter
  }
  
  var monthDayYearString: String {
    let dateFormatter = Date.bankeyDateFormatter
    dateFormatter.dateFormat = "MMM d, yyyy"
    return dateFormatter.string(from: self)
  }
}
