//
//  Item.swift
//  VeggieKitchen
//
//  Created by julie ryan on 30/07/2024.
//

import Foundation 
import SwiftData

@Model
final class Meal {
    
    let id = UUID().uuidString
    
    
    var date : Date
    
    var title : String
    var instructions : String
    var ingredients : [IngredientMeal]
    init(date: Date, title: String, instructions: String, extendedIngredients: [IngredientMeal]) {
        self.date = date
        self.title = title
        self.instructions = instructions
        self.ingredients = extendedIngredients
    }
    
    
}
