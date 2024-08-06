//
//  IngredientMeal.swift
//  VeggieKitchen
//
//  Created by julie ryan on 05/08/2024.
//

import Foundation


import SwiftData

@Model
final class IngredientMeal {
    let id = UUID().uuidString
    let original: String
    init(original: String) {
        self.original = original
    }
}

