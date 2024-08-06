//
//  RecipeListLoader.swift
//  VeggieKitchen
//
//  Created by julie ryan on 30/07/2024.
//



import Foundation
import SwiftUI

class RecipeListLoader: ObservableObject {
    @Published var recipes: [RowRecipes] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let recipeService: RecipesService
     
     // Constructeur pour l'injection de dépendances
     init(recipeService: RecipesService) {
         self.recipeService = recipeService
     }
    
    
    func fetchRecipes() {
        isLoading = true
        error = nil
        
        recipeService.fetchRecipes { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let recipes):
                    self?.recipes = recipes
                case .failure(let fetchError):
                    self?.error = fetchError
                    print("Failed to fetch recipes:", fetchError)
                }
            }
        }
    }
}
