//
//  Item.swift
//  VeggieKitchen
//
//  Created by julie ryan on 06/08/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
