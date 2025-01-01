//
//  String.swift
//  Parceit
//
//  Created by Mert Ozseven on 1.01.2025.
//

import Foundation

extension String {
    func formattedDate() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withFullTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        
        // Parse the date
        if let date = formatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM d, yyyy, 'at' HH:mm" // Custom format
            return outputFormatter.string(from: date)
        } else {
            // Fallback to DateFormatter if ISO8601 fails
            let fallbackFormatter = DateFormatter()
            fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            if let fallbackDate = fallbackFormatter.date(from: self) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "MMMM d, yyyy, 'at' HH:mm" // Custom format
                return outputFormatter.string(from: fallbackDate)
            }
        }
        
        return self // Return the original string if formatting fails
    }
}
