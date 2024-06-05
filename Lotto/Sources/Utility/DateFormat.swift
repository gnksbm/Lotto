//
//  DateFormat.swift
//  Lotto
//
//  Created by gnksbm on 6/4/24.
//

import Foundation

enum DateFormat: String {
    case lottoDate = "yyyy-MM-dd"
}

extension DateFormat {
    private static var cachedStorage = [DateFormat: DateFormatter]()
    
    var formatter: DateFormatter {
        if let formatter = Self.cachedStorage[self] {
            return formatter
        } else {
            let newFormatter = DateFormatter()
            newFormatter.dateFormat = self.rawValue
            newFormatter.locale = Locale(identifier: "ko_KR")
            Self.cachedStorage[self] = newFormatter
            return newFormatter
        }
    }
}

extension String {
    func formatted(dateFormat: DateFormat) -> Date? {
        dateFormat.formatter.date(from: self)
    }
}

extension Date {
    func formatted(dateFormat: DateFormat) -> String {
        dateFormat.formatter.string(from: self)
    }
}
