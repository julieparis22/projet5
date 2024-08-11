//
//  CalendarManager .swift
//  VeggieKitchen
//
//  Created by julie ryan on 05/08/2024.
//

import Foundation
import EventKit
import SwiftUI
import EventKit

class CalendarManager: ObservableObject {
    let eventStore = EKEventStore()
     
     func checkCalendarAuthorizationStatus() -> EKAuthorizationStatus {
         return EKEventStore.authorizationStatus(for: .event)
     }

    
    
    func requestCalendarAccess(completion: @escaping (Bool, Error?) -> Void) {
          if #available(iOS 17.0, *) {
              eventStore.requestFullAccessToEvents { granted, error in
                  DispatchQueue.main.async {
                      completion(granted, error)
                  }
              }
          } else {
              eventStore.requestAccess(to: .event) { granted, error in
                  DispatchQueue.main.async {
                      completion(granted, error)
                  }
              }
          }
      }
    
    func addEventToCalendar(title: String, startDate: Date, endDate: Date, instructions: String, ingredients: [IngredientMeal], completion: @escaping (Bool, Error?) -> Void) {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        
        var notes = ""
        if !ingredients.isEmpty {
            let ingredientsList = ingredients.map { $0.original }.joined(separator: ", ")
            notes += "\n\nIngredients: \(ingredientsList)"
        }
        notes += "\n\nInstructions:\n\(instructions)"
        event.notes = notes
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            completion(true, nil)
        } catch let error {
            completion(false, error)
        }
    }
    
    func fetchEvents(startDate: Date, endDate: Date, completion: @escaping ([EKEvent]?, Error?) -> Void) {
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let events = eventStore.events(matching: predicate)
        completion(events, nil)
    }
    
    func deleteEvent(_ event: EKEvent, completion: @escaping (Bool, Error?) -> Void) {
        do {
            try eventStore.remove(event, span: .thisEvent)
            completion(true, nil)
        } catch {
            completion(false, error)
        }
    }
}


