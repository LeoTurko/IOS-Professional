//
//  DecimalUtils.swift
//  Bankey
//
//  Created by Леонид Турко on 19.08.2024.
//

import Foundation

extension Decimal {
  var doubleValue: Double {
    NSDecimalNumber(decimal: self).doubleValue
  }
}
