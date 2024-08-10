//
//  CalendarManager .swift
//  VeggieKitchen
//
//  Created by julie ryan on 05/08/2024.
//

import Foundation
import EventKit
struct CalendarManager {
    private let eventStore = EKEventStore()
    
    // Fonction pour demander l'autorisation d'accès au calendrier
    func requestCalendarAccess(completion: @escaping (Bool, Error?) -> Void) {
        // Vérifier le statut d'autorisation
        let status = EKEventStore.authorizationStatus(for: .event)
        
        switch status {
        case .notDetermined:
            // Demander l'accès complet aux événements
            eventStore.requestFullAccessToEvents { granted, error in
                DispatchQueue.main.async {
                    completion(granted, error)
                }
            }
        case .authorized:
            // Déjà autorisé
            completion(true, nil)
        case .denied, .restricted:
            // Accès refusé ou restreint
            completion(false, nil)
        case .fullAccess:
            print("full acess")
        case .writeOnly:
            print("write only")
        @unknown default:
            // Gérer les futurs cas inconnus
            completion(false, nil)
        }
    }
    
    // Fonction pour ajouter un événement au calendrier
    func addEventToCalendar(title: String, startDate: Date, endDate: Date, instructions: String, ingredients: [IngredientMeal], completion: @escaping (Bool, Error?) -> Void) {
        // Créer un nouvel événement
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        
        // Préparer les notes de l'événement
        
        
        
        var notes = ""
        
        if !ingredients.isEmpty {
            let ingredientsList = ingredients.map { $0.original }.joined(separator: ", ")
            notes += "\n\nIngrédients: \(ingredientsList)"
        }
        
    //    notes += "\n\nInstructions:\n"
        notes +=  instructions

        event.notes = notes
        event.calendar = eventStore.defaultCalendarForNewEvents

        do {
            // Sauvegarder l'événement
            try eventStore.save(event, span: .thisEvent)
            completion(true, nil)
        } catch let error {
            // Gérer les erreurs
            completion(false, error)
        }
    }
    
    // Fonction pour récupérer les événements du calendrier
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
