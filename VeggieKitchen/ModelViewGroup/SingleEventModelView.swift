//
//  SingleEventModelView.swift
//  VeggieKitchen
//
//  Created by julie ryan on 09/08/2024.
//

import SwiftUI
import EventKit

struct SingleEventModelView: View {
    @Binding var event: EKEvent
    @State private var webViewHeight: CGFloat = .zero
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(event.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text("Date: \(event.startDate, formatter: customDateFormatter)")
        
            
            if let notes = event.notes, !notes.isEmpty {
                HTMLTextView(htmlContent: notes, dynamicHeight: $webViewHeight)
                    .frame(height: webViewHeight)
            }
        }
        .padding()
    }
}

#Preview {
    let eventStore = EKEventStore()
    let event = EKEvent(eventStore: eventStore)
    event.title = "Événement test"
    event.startDate = Date()
    event.endDate = Date().addingTimeInterval(3600)
    event.location = "Paris, France"
    event.notes = "Ceci est un événement de test pour le preview."
    
    return SingleEventModelView(event: .constant(event))
}
