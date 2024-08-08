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
    @State  var summary: String = ""
    @State  var date: Date = Date()
    @State  var ingredients : [IngredientMeal] = []
    @State  var isMealAdded = false
    @State  var errorMessage: String?
    @State  var calendarManager = CalendarManager()
    @State  var addedMealTitle: String = ""
    
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {

         Button("Ajouter Repas et Événement") {
                        addMealAndEvent()
                    }
        DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
        if  let errorMessage = errorMessage {
            Text("Erreur: \(errorMessage)")
                .foregroundColor(.red)
        }
                 
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
                
                calendarManager.addEventToCalendar(title: eventTitle, startDate: startDate, endDate: endDate, instructions: meal.instructions) { success, error in
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
    AddMealView(title: .constant(""), ingredients: [IngredientMeal(original: "bob")])
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
