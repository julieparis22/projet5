//
//  Recipe.swift
//  VeggieKitchen
//
//  Created by julie ryan on 31/07/2024.
//

import Foundation
struct Recipe : Codable {
    let extendedIngredients : [Ingredient]
    let id: Int
    let title: String
    let readyInMinutes : Int
    let image: String
    var imageType: String = "jpg"
    let summary : String
  
    }
