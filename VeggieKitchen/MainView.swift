//
//  MainView.swift
//  VeggieKitchen
//
//  Created by julie ryan on 30/07/2024.
//

import SwiftUI

struct MainView: View {
   
    var body: some View {
   Text("main view")
        let recipeService = RealRecipesService()
      
        TabView {
            RecipesListView(recipeService: recipeService)
                            .tabItem {
                                Image(systemName: "plus.circle.fill")
                                Text("Ajouter element")
                            }
            
            CalendarEventsView(
                
                startDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
                
                endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
                
            )  .tabItem {
                Image(systemName: "list.bullet")
                Text("Calendar")
                    }
                        
            AddMealView(ingredients: [IngredientMeal(original: "bob")])  .tabItem {
                Image(systemName: "plus.circle.fill")
                Text("Ajouter element")
            }
            }

  //  RecipesListView()
    }
}

#Preview {
    MainView()
}
/**
 
 
         CalendarEventsView(
             
             startDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
             
             endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
             
         )  .tabItem {
             Image(systemName: "list.bullet")
             Text("Calendar")
                 }
 
 */
