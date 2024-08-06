//
//  MockRecipesService.swift
//  VeggieKitchenTests
//
//  Created by julie ryan on 31/07/2024.
//


import Foundation
import Combine


class MockRecipesService: RecipesService {
    private let mockData: Data?
    private let mockError: Error?

    init(mockData: Data? = nil, mockError: Error? = nil) {
        self.mockData = mockData
        self.mockError = mockError
    }


    func fetchRecipeDetails(recipeId: Int) -> AnyPublisher<Recipe, Error> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }

        guard let data = mockData else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }

        return Just(data)
            .decode(type: Recipe.self, decoder: JSONDecoder())
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }


    override func fetchRecipes(isVegan: Bool, isVegetarian: Bool, completion: @escaping (Result<[RowRecipes], Error>) -> Void) {
        if let error = mockError {
            completion(.failure(error))
            return
        }

        guard let data = mockData else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }

        do {
            let apiResponse = try JSONDecoder().decode(Recipes.self, from: data)
            completion(.success(apiResponse.results))
        } catch {
            completion(.failure(error))
        }
    }
}
