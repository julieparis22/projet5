//
//  CalendarEventsView.swift
//  VeggieKitchen
//
//  Created by julie ryan on 05/08/2024.
//

import SwiftUI
import EventKit
import UIKit

struct CalendarEventsView: View {
    @State private var events: [EKEvent] = []
    @State private var calendarManager = CalendarManager()
    @State private var errorMessage: String?

    let startDate: Date
    let endDate: Date

    var body: some View {
        NavigationView {
            
        VStack {
            if !events.isEmpty {
                List(events, id: \.eventIdentifier) { event in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(event.title)
                                .font(.headline)
                            Text(event.notes ?? "Aucune note")
                            
                            Text("Début: \(event.startDate, formatter: eventFormatter)")
                            Text("Fin: \(event.endDate, formatter: eventFormatter)")
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            deleteEvent(event)
                        }) {
                            Text("Supprimer")
                                .foregroundColor(.red)
                        }
                    }
                }
            } else if let errorMessage = errorMessage {
                Text("Erreur: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                Text("Aucun événement trouvé.")
            }
        }
        .onAppear {
            fetchEvents()
        }
    }
            
        .navigationTitle("Événements du Calendrier")
    }
    
   func fetchEvents() {
        calendarManager.requestCalendarAccess { granted, error in
            if granted {
                calendarManager.fetchEvents(startDate: startDate, endDate: endDate) { fetchedEvents, error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    } else {
                        events = fetchedEvents ?? []
                    }
                }
            } else {
                errorMessage = error?.localizedDescription ?? "Accès au calendrier refusé."
            }
        }
    }
    
    private func deleteEvent(_ event: EKEvent) {
        calendarManager.requestCalendarAccess { granted, error in
            if granted {
                calendarManager.deleteEvent(event) { success, error in
                    if success {
                        fetchEvents() // Recharger les événements après la suppression
                    } else {
                        errorMessage = error?.localizedDescription ?? "Erreur lors de la suppression de l'événement."
                    }
                }
            } else {
                errorMessage = error?.localizedDescription ?? "Accès au calendrier refusé."
            }
        }
    }
    
    private var eventFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}


#Preview {
    CalendarEventsView(startDate: Date(), endDate: Date().addingTimeInterval(3600 * 24 * 30))
}
