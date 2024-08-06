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
    @State var mealTitle: String = ""
    @State  var mealInstructions: String = ""
    @State  var mealDate: Date = Date()
    @State  var ingredients : [IngredientMeal]
    @State  var isMealAdded = false
    @State  var errorMessage: String?
    @State  var calendarManager = CalendarManager()
    @State  var addedMealTitle: String = ""
    
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Détails du Repas")) {
                    TextField("Titre du repas", text: $mealTitle)
                    DatePicker("Date", selection: $mealDate, displayedComponents: [.date, .hourAndMinute])
                    TextEditor(text: $mealInstructions)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                        .overlay(
                            Group {
                                if mealInstructions.isEmpty {
                                    Text("Instructions du repas")
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 8)
                                }
                            },
                            alignment: .topLeading
                        )
                }
                
                Section {
                    Button("Ajouter Repas et Événement") {
                        addMealAndEvent()
                    }
                }
                
                if isMealAdded {
                    Section {
                        Text("Repas ajouté: \(addedMealTitle)")
                            .foregroundColor(.green)
                    }
                } else if let errorMessage = errorMessage {
                    Section {
                        Text("Erreur: \(errorMessage)")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Ajouter un Repas")
        }
    }
    
    private func addMealAndEvent() {
        guard !mealTitle.isEmpty else {
            errorMessage = "Le titre du repas ne peut pas être vide."
            return
        }
        
        let meal = Meal(date: mealDate, title: mealTitle, instructions: mealInstructions, ingredients: [IngredientMeal(original: "tomato")])
                        
                        
                        
        modelContext.insert(meal)
        
        calendarManager.requestCalendarAccess { granted, error in
            if granted {
                let eventTitle = meal.title
                let startDate = meal.date
                let endDate = Calendar.current.date(byAdding: .hour, value: 1, to: meal.date) ?? meal.date
                
                calendarManager.addEventToCalendar(title: eventTitle, startDate: startDate, endDate: endDate, instructions: meal.instructions) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            isMealAdded = true
                            addedMealTitle = eventTitle
                            errorMessage = nil
                            
                            // Réinitialiser les champs après l'ajout réussi
                            mealTitle = ""
                            mealInstructions = ""
                            mealDate = Date()
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
    AddMealView(ingredients: [IngredientMeal(original: "bob")])
}
