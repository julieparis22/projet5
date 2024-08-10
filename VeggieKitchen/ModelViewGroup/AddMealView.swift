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
    @Binding var summary: String
    @State private var date: Date = Date()
    @State private var ingredients: [IngredientMeal] = []
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
            
            DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                .padding()
        
            if let errorMessage = errorMessage {
                Text("Erreur: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
            if isMealAdded {
                Text("👍🏼")
                    .padding()
            }
        }
        .padding()
    }
    
    private func addMealAndEvent() {
        guard !title.isEmpty else {
            errorMessage = "Le titre du repas ne peut pas être vide."
            return
        }
        
        let meal = Meal(date: date, title: title, instructions: summary, ingredients: [IngredientMeal(original: "tomato")])
        
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
                            summary = ""
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
    AddMealView(title: .constant("Exemple Titre"), summary: .constant("Exemple recette"))
}
/*
 
 Section(header: Text("Détails du Repas")) {
     TextField("Titre du repas", text: $title)
     DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
     TextEditor(text: $summary)
         .frame(height: 100)
         .overlay(
             RoundedRectangle(cornerRadius: 8)
                 .stroke(Color.secondary.opacity(0.2), lineWidth: 1))
         .overlay(Group {
                 if summary.isEmpty {
                     Text("Instructions du repas")
                         .foregroundColor(.secondary)
                         .padding(.horizontal, 4)
                         .padding(.vertical, 8)
                 }
             },
             alignment: .topLeading
         )
 }
 
 **/
