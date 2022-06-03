//
//  Date+Extension.swift
//  Appetiser Code Challenge
//
//  Created by Ariel Dominic Cabanag on 2/5/22.
//

import Foundation
extension Date {
    /// Converts Date to a formatted string
    /// - Parameter format: The `format` of the output string.
    func string(output format: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
