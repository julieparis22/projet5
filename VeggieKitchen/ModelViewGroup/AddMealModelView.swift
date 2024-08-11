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

struct AddMealModelView: View {
    @Binding var title: String
    @Binding var instructions: String
    @State private var date: Date = Date()
    var currentDate = Date()
  
     private var endDate: Date {
         Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
     }

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
                           in: currentDate...endDate,
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

        
        let meal = Meal(date: date, title: title, instructions: instructions,  extendedIngredients: ingredients)
    
        
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
                 
                            title = ""
                            instructions = ""
                            date = Date()
                            
                        } else {
                            isMealAdded = false
                            errorMessage = error?.localizedDescription ?? "Error while adding event."
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = error?.localizedDescription ?? "Acces denied."
                    isMealAdded = false
                }
            }
        }
    }
}

#Preview {
    AddMealModelView(title: .constant("Exemple Titre"), instructions: .constant("Exemple recette"), ingredients: [IngredientMeal(original: "tomato")])
}

