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
        
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(event.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("\(event.startDate, formatter: customDateFormatter)")
            
                
                if let notes = event.notes, !notes.isEmpty {
                    
                    Text("\(notes)")
         
                }
            }
            .padding()
        }
    
    }
}

#Preview {
    let eventStore = EKEventStore()
    let event = EKEvent(eventStore: eventStore)
    event.title = "title"
    event.startDate = Date()
    event.endDate = Date().addingTimeInterval(3600)
    event.location = "Paris, France"
    event.notes = "notes"
    
    return SingleEventModelView(event: .constant(event))
}
