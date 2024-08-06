//
//  Recipes.swift
//  VeggieKitchen
//
//  Created by julie ryan on 30/07/2024.
//

import Foundation

struct Recipes: Codable {
    let results: [RowRecipes]
    let offset: Int
    let number: Int
    let totalResults: Int
}
