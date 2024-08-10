//
//  MainView.swift
//  VeggieKitchen
//
//  Created by julie ryan on 30/07/2024.
//

import SwiftUI

struct MainView: View {

    let recipeService = RealRecipesService()
    var body: some View {

        TabView {
            RecipesListView(recipeService: recipeService)
                            .tabItem {
                                Image(systemName: "list.bullet")
                                Text("Recipes")
                            }
            
            CalendarEventsView(
                
                startDate: Calendar.current.date(byAdding: .day, value: 0, to: Date()) ?? Date(),
                
                endDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
                
            )  .tabItem {
                Image(systemName: "calendar")
                Text("Agenda")
                    }
                        
   
            }


    }
}

#Preview {
    MainView()
}
