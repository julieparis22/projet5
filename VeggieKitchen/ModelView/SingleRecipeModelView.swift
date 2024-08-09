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
       @Environment(\.modelContext) var modelContext
       
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
             
        
                       Text(recipe.title)
                           .font(.largeTitle)
                           .multilineTextAlignment(.center)
                       AddMealView(title: .constant(recipe.title), summary: .constant(recipe.summary))
             
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
               }
               .padding()
           }
           .onAppear {
               loadRecipe()
           }
           .onChange(of: id) { _, _ in
               loadRecipe()
           }
       }
       
    private func loadRecipe() {
         recipeDetails.fetchRecipeDetails(recipeId: id)
     }
}

#Preview {
    SingleRecipeModelView(id: .constant(2))
}
