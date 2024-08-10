//
//  CustomDateFormatter.swift
//  VeggieKitchen
//
//  Created by julie ryan on 10/08/2024.
//

import Foundation

public var customDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}
