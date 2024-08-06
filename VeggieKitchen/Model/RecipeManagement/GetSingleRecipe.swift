//
//  GetSingleRecipe.swift
//  VeggieKitchen
//
//  Created by julie ryan on 31/07/2024.
//

import Combine
import Foundation
import SwiftUI

// First, let's define a protocol that both RealRecipesService and MockRecipesService will conform to
protocol RecipesServiceProtocol {
    func fetchRecipeDetails(recipeId: Int) -> AnyPublisher<Recipe, Error>
}

// Make sure both RealRecipesService and MockRecipesService conform to this protocol
extension RealRecipesService: RecipesServiceProtocol {}
extension MockRecipesService: RecipesServiceProtocol {}

class GetSingleRecipe: ObservableObject {
    @Published var recipe: Recipe?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let recipeService: RecipesServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // Updated constructor to use the protocol
    init(recipeService: RecipesServiceProtocol) {
        self.recipeService = recipeService
    }
    
    // The rest of the class remains the same
    func fetchRecipeDetails(recipeId: Int) {
        isLoading = true
        
        recipeService.fetchRecipeDetails(recipeId: recipeId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] recipe in
                self?.recipe = recipe
            })
            .store(in: &cancellables)
    }
}

