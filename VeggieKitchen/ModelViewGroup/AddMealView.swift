//
//  AddMealView.swift
//  VeggieKitchen
//
//  Created by julie ryan on 05/08/2024.
//
import SwiftUI
import SwiftData
import Foundation
import EventKit

struct AddMealView: View {
    @Binding var title: String
    @Binding var instructions: String
    @State private var date: Date = Date()
    private let currentDate = Date()
    var ingredients: [IngredientMeal]
    @State private var isMealAdded = false
    @State private var errorMessage: String?
    @State private var calendarManager = CalendarManager()
    @State private var addedMealTitle: String = ""
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        HStack {
            Button("+") {
                addMealAndEvent()
            }.font(.largeTitle)
            .padding()
            
            DatePicker(
                      " ",
                      selection: $date,
                      in: currentDate...,
                      displayedComponents: [.date, .hourAndMinute]
                  )
                  .padding()
        
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
            if isMealAdded {
                Text("👍🏼 !")
                    .padding()
            }else {
                Text("🥣 ? ")
                    .padding()
            }
        }
        .padding()
    }
    
    private func addMealAndEvent() {
        guard !title.isEmpty else {
            errorMessage = "You need to give a title."
            return
        }

        
        let meal = Meal(date: date, title: title, instructions: instructions,  ingredients: ingredients)
    
        
        modelContext.insert(meal)
        
        calendarManager.requestCalendarAccess { granted, error in
            if granted {
                let eventTitle = meal.title
                let startDate = meal.date
                let endDate = Calendar.current.date(byAdding: .hour, value: 1, to: meal.date) ?? meal.date
                
                calendarManager.addEventToCalendar(title: eventTitle, startDate: startDate, endDate: endDate, instructions: meal.instructions, ingredients: meal.ingredients) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            isMealAdded = true
                            addedMealTitle = eventTitle
                            errorMessage = nil
                            
                            // Réinitialiser les champs après l'ajout réussi
                            title = ""
                            instructions = ""
                            date = Date()
                        } else {
                            isMealAdded = false
                            errorMessage = error?.localizedDescription ?? "Erreur inconnue lors de l'ajout de l'événement."
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = error?.localizedDescription ?? "Accès au calendrier refusé."
                    isMealAdded = false
                }
            }
        }
    }
}

#Preview {
    AddMealView(title: .constant("Exemple Titre"), instructions: .constant("Exemple recette"), ingredients: [IngredientMeal(original: "tomato")])
}

