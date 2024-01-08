//
//  BusinessUtils.swift
//  WorldOfPAYBACK
//
//  Created by Oleg Kasarin on 07/01/2024.
//

import Foundation

struct BusinessUtils {
    
    static var currencySign: String {
        "PBP"
    }
    
    // MARK: - Date formatter
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter
    }
    
    // MARK: - Date display
    
    static func displayDateString(fromDate date: Date, format: PBDateFormat) -> String {
        let formatter = dateFormatter
        formatter.dateFormat = format.rawValue
        return formatter.string(from: date)
    }
    
    static func displaySmartDateString(date: Date) -> String {
        date.isCurrentYear
            ? displayDateString(fromDate: date, format: .dMMM)
            : displayDateString(fromDate: date, format: .dMMMYYYY)
    }
}

// MARK: - Date format

enum PBDateFormat: String {
    case dMMM     = "d MMM"
    case dMMMYYYY = "d MMM YYYY"
    case HHmm     = "HH:mm"
}

// MARK: - Date extension

extension Date {
    var isCurrentYear: Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
}
