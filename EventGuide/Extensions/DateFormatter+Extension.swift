//
//  DateFormatter+Extension.swift
//  EventGuide
//
//  Created by Anup Deshpande on 1/26/21.
//

import Foundation

extension DateFormatter{
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    static let dayMonthYearTimeFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, YYYY h:mm a"
        return formatter
    }()
        
    static let dayMonthYearFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, YYYY"
        return formatter
    }()
}
