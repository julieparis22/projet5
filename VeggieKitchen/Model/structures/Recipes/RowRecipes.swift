//
//  Recipe.swift
//  VeggieKitchen
//
//  Created by julie ryan on 30/07/2024.
//

import Foundation


struct RowRecipes: Codable, Identifiable {
    let id: Int
    let title: String
    let image: String
    var imageType: String = "jpg"
 
}
