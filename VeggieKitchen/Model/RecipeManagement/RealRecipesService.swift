//
//  RealRecipesService.swift
//  VeggieKitchen
//
//  Created by julie ryan on 31/07/2024.
//

import Foundation
import Combine


class RealRecipesService: RecipesService {
    

     let apiKey = "b560c6029ad049b681ae7a81c9a3142b"
     let baseURL = "https://api.spoonacular.com/recipes"

      // Implémentation de la méthode fetchRecipes
    override  func fetchRecipes(isVegan: Bool = false, isVegetarian: Bool = true, completion: @escaping (Result<[RowRecipes], Error>) -> Void) {
          var urlComponents = URLComponents(string: "\(baseURL)/complexSearch")
          urlComponents?.queryItems = [
              URLQueryItem(name: "apiKey", value: apiKey),
              URLQueryItem(name: "vegan", value: isVegan ? "true" : nil),
              URLQueryItem(name: "vegetarian", value: isVegetarian ? "true" : nil)
          ].compactMap { $0 }

          guard let url = urlComponents?.url else {
              completion(.failure(URLError(.badURL)))
              return
          }

          network.dataTask(with: url) { data, _, error in
              if let error = error {
                  completion(.failure(error))
                  return
              }

              guard let data = data else {
                  completion(.failure(URLError(.cannotParseResponse)))
                  return
              }

              do {
                  let apiResponse = try JSONDecoder().decode(Recipes.self, from: data)
                  completion(.success(apiResponse.results))
              } catch {
                  completion(.failure(error))
              }
          }.resume()
      }

      // Implémentation de la méthode fetchRecipeDetails avec Combine
      func fetchRecipeDetails(recipeId: Int) -> AnyPublisher<Recipe, Error> {
          let urlString = "\(baseURL)/\(recipeId)/information?apiKey=\(apiKey)"
          
          guard let url = URL(string: urlString) else {
              return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
          }
          
          return URLSession.shared.dataTaskPublisher(for: url)
              .map(\.data)
              .decode(type: Recipe.self, decoder: JSONDecoder())
              .eraseToAnyPublisher()
      }
}
