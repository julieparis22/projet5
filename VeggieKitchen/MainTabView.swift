//
//  MainView.swift
//  VeggieKitchen
//
//  Created by julie ryan on 30/07/2024.
//

import SwiftUI
import EventKit

struct MainTabView: View {
    let recipeService = RealRecipesService()
    @State private var calendarAccessGranted = false
    
    var body: some View {
        ZStack {
            if calendarAccessGranted {
                TabView {
                    RecipesListView(recipeService: recipeService)
                        .tabItem {
                            Image(systemName: "list.bullet")
                            Text("Recipes")
                        }
                    
                    CalendarEventsView(
                        startDate: Calendar.current.date(byAdding: .day, value: 0, to: Date()) ?? Date(),
                        endDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
                    )
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Agenda")
                    }
                }
            } else {
                CalendarAccessView(onAccessGranted: {
                    calendarAccessGranted = true
                })
            }
        }
    }
}

#Preview {
    MainTabView()
}
