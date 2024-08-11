//
//  VeggieKitchenApp.swift
//  VeggieKitchen
//
//  Created by julie ryan on 30/07/2024.
//

import SwiftUI
import SwiftData

@main
struct VeggieKitchenApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Meal.self,IngredientMeal.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
