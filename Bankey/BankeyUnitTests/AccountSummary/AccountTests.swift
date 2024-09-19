//
//  AccountTests.swift
//  BankeyUnitTests
//
//  Created by Леонид Турко on 19.09.2024.
//

import Foundation
import XCTest

@testable import Bankey

class AccountTests: XCTestCase {
  
  override class func setUp() {
    super.setUp()
  }
  
  func testCanParse() throws {
    let json = """
           [
             {
               "id": "1",
               "type": "Banking",
               "name": "Basic Savings",
               "amount": 929466.23,
               "createdDateTime" : "2010-06-21T15:29:32Z"
             },
             {
               "id": "2",
               "type": "Banking",
               "name": "No-Fee All-In Chequing",
               "amount": 17562.44,
               "createdDateTime" : "2011-06-21T15:29:32Z"
             },
            ]
          """
    
    let data = json.data(using: .utf8)!
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    let results = try decoder.decode([Account].self, from: data)
    
    XCTAssertEqual(results.count, 2)
    
    let result = results[0]
    XCTAssertEqual(result.id, "1")
    XCTAssertEqual(result.type, .Banking)
    XCTAssertEqual(result.name, "Basic Savings")
    XCTAssertEqual(result.amount, 929466.23)
    XCTAssertEqual(result.createdDateTime.monthDayYearString, "Jun 21, 2010")
  }
}
