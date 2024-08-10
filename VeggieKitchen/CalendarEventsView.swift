//
//  CalendarEventsView.swift
//  VeggieKitchen
//
//  Created by julie ryan on 05/08/2024.
//

import SwiftUI

import EventKit

struct CalendarEventsView: View {
    @State private var events: [EKEvent] = []
    @State private var calendarManager = CalendarManager()
    @State private var errorMessage: String?
    let startDate: Date
    let endDate: Date

    var body: some View {
        NavigationStack {
            VStack {
                if !events.isEmpty {
                    List(events, id: \.eventIdentifier) { event in
                        NavigationLink(destination: SingleEventModelView(event: .constant(event))) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(event.title)
                                        .font(.headline)
                                    Text(" \(event.startDate, formatter: customDateFormatter)")
                         
                                
                                    
                                }
                                Spacer()
                                
                            }
                        }
                        Button(action: {
                            deleteEvent(event)
                        }) {
                            HStack {
                                Text("Delete")
                                Text("🗑️")
                                    .foregroundColor(.red)
                            }
                           
                        }
                   
                    }
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    Text("No event found")
                }
            }
            .onAppear {
                fetchEvents()
            }
            .navigationTitle("Meals by day")
        }
    }
    
    private func deleteEvent(_ event: EKEvent) {
          calendarManager.requestCalendarAccess { granted, error in
              if granted {
                  calendarManager.deleteEvent(event) { success, error in
                      if success {
                          fetchEvents()
                      } else {
                          errorMessage = error?.localizedDescription ?? "Error while deleting."
                      }
                  }
              } else {
                  errorMessage = error?.localizedDescription ?? "Access denied."
              }
          }
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
                errorMessage = error?.localizedDescription ?? "access denied."
            }
        }
    }


}


#Preview {
    CalendarEventsView(startDate: Date(), endDate: Date().addingTimeInterval(3600 * 24 * 30))
}
