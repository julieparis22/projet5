//
//  GetRecipes.swift
//  VeggieKitchen
//
//  Created by julie ryan on 31/07/2024.
//

import Foundation
import Foundation

class RecipesService {
    private let apiKey = "b560c6029ad049b681ae7a81c9a3142b"
        private let baseURL = "https://api.spoonacular.com/recipes"

         let network: Networking

        // Initialisateur pour l'injection de dépendances
        init(network: Networking = URLSession.shared) {
            self.network = network
        }

        // Fonction pour obtenir les recettes
        func fetchRecipes(isVegan: Bool = false, isVegetarian: Bool = true, completion: @escaping (Result<[RowRecipes], Error>) -> Void) {
            // Construire la chaîne de requête basée sur le type de régime
            var urlComponents = URLComponents(string: "\(baseURL)/complexSearch")
            urlComponents?.queryItems = [
                URLQueryItem(name: "apiKey", value: apiKey),
                URLQueryItem(name: "vegan", value: isVegan ? "true" : nil),
                URLQueryItem(name: "vegetarian", value: isVegetarian ? "true" : nil)
            ].compactMap { $0 } // Supprimer les queryItems avec une valeur nulle

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

        // Fonction pour obtenir les détails d'une recette par son ID
        func fetchRecipeDetails(recipeId: Int, completion: @escaping (Result<Recipe, Error>) -> Void) {
            var urlComponents = URLComponents(string: "\(baseURL)/\(recipeId)/information")
            let queryItems = [
                URLQueryItem(name: "apiKey", value: apiKey)
            ]
            
            urlComponents?.queryItems = queryItems

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
                    let recipe = try JSONDecoder().decode(Recipe.self, from: data)
                    completion(.success(recipe))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
}
