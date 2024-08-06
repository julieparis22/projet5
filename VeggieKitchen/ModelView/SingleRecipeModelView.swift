//
//  SingleRecipeModelView.swift
//  VeggieKitchen
//    HTMLTextView(htmlContent: wrapHtmlContent(recipe.summary))
//.frame(height: webViewHeight)
//  Created by julie ryan on 01/08/2024.
//

import SwiftUI
import WebKit

struct SingleRecipeModelView: View {
    @Binding var id: Int
    @StateObject private var recipeDetails = GetSingleRecipe(recipeService: RealRecipesService())
    @State private var webViewHeight: CGFloat = .zero

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if recipeDetails.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = recipeDetails.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else if let recipe = recipeDetails.recipe {
                    VStack(alignment: .center, spacing: 16) {
                        Text(recipe.title)
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                        
                        AsyncImage(url: URL(string: recipe.image)) { image in
                            image.resizable()
                                 .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 200)
                        
                        Text("Ready in \(recipe.readyInMinutes) minutes")
                            .font(.subheadline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ingredients")
                                .font(.headline)
                            
                            ForEach(recipe.extendedIngredients, id: \.id) { ingredient in
                                IngredientsModelView(ingredient: .constant(ingredient))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Instructions")
                                .font(.headline)
                            
                            HTMLTextView(htmlContent: recipe.summary, dynamicHeight: $webViewHeight)
                                .frame(height: webViewHeight)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            recipeDetails.fetchRecipeDetails(recipeId: id)
        }
        .onChange(of: id) { oldValue, newValue in
                 // Utilisez oldValue et newValue ici
                 recipeDetails.fetchRecipeDetails(recipeId: newValue)
             }
    }
}

#Preview {
    SingleRecipeModelView(id: .constant(2))
}
