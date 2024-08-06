//
//  RecipesListView.swift
//  VeggieKitchen
//
//  Created by julie ryan on 30/07/2024.
//

import SwiftUI

struct RecipesListView: View {
    @StateObject private var loader: RecipeListLoader
    
    // Initialisateur pour l'injection de dépendances
    init(recipeService: RecipesService) {
        _loader = StateObject(wrappedValue: RecipeListLoader(recipeService: recipeService))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if loader.isLoading {
                    ProgressView()
                } else if let error = loader.error {
                    Text("Error: \(error.localizedDescription)")
                        .foregroundColor(.red)
                } else {
                    List(loader.recipes, id: \.id) { recipe in
                        NavigationLink(destination: SingleRecipeModelView(id: .constant(recipe.id))) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(recipe.title)
                                        .font(.headline)
                                }
                                
                                Spacer()
                                
                                if let imageUrl = URL(string: recipe.image) {
                                    AsyncImage(url: imageUrl) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 60, height: 60)
                                    .aspectRatio(contentMode: .fit)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                loader.fetchRecipes()
            }
        }
    }
}


#Preview {
    RecipesListView(recipeService: RealRecipesService())
}
/*#Preview {
 RecipeListView(recipeService: MockRecipesServiceForView())
}
**/
