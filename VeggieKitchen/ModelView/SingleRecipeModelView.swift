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
                       Text("Erreur: \(error)")
                           .foregroundColor(.red)
                           .padding()
                   } else if let recipe = recipeDetails.recipe {
                       HStack {
                           Spacer()
                           Text(recipe.title)
                               .font(.largeTitle)
                               .multilineTextAlignment(.center)
                           Spacer()
                       }
        
                     
                       AddMealView(
                                            title: .constant(recipe.title),
                                            instructions: .constant(recipe.instructions),
                                            ingredients: recipe.extendedIngredients.map { IngredientMeal(original: $0.original) }
                                        )
                       HStack {
                           Spacer()
                           AsyncImage(url: URL(string: recipe.image)) { image in
                               image.resizable()
                                    .aspectRatio(contentMode: .fit)
                           } placeholder: {
                               ProgressView()
                           }
                           Spacer()
                       }
               
                       .frame(height: 200)
                       
                       HStack {
                           Spacer()
                           Text("⏲ \(recipe.readyInMinutes) minutes")
                               .font(.subheadline)
                           Spacer()
                       }
                      
                       VStack(alignment: .leading, spacing: 8) {
                           HStack {
                               Spacer()
                               Text("Ingredients")
                               Spacer()
                           }
                        
                               .font(.headline)
                           ForEach(recipe.extendedIngredients, id: \.id) { ingredient in
                               IngredientsModelView(ingredient: .constant(ingredient))
                           }
                       }
                       VStack(alignment: .leading, spacing: 8) {
                           HStack {
                               Spacer()
                               Text("instructions :").fontWeight(.bold)
                               Spacer()
                           }
                           HStack {
                               Spacer()
                               HTMLTextView(htmlContent: recipe.instructions, dynamicHeight: $webViewHeight)
                                   .frame(height: webViewHeight)
                               Spacer()
                           }
                       
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
