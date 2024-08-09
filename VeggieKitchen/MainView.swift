//
//  MainView.swift
//  VeggieKitchen
//
//  Created by julie ryan on 30/07/2024.
//

import SwiftUI

struct MainView: View {
    @State var title = "tomato"
    let recipeService = RealRecipesService()
    var body: some View {
   Text("main view")
 
      
        TabView {
            RecipesListView(recipeService: recipeService)
                            .tabItem {
                                Image(systemName: "plus.circle.fill")
                                Text("Ajouter element")
                            }
            
            CalendarEventsView(
                
                startDate: Calendar.current.date(byAdding: .day, value: 0, to: Date()) ?? Date(),
                
                endDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
                
            )  .tabItem {
                Image(systemName: "list.bullet")
                Text("Calendar")
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
