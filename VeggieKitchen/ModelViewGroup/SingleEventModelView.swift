//
//  SingleEventModelView.swift
//  VeggieKitchen
//
//  Created by julie ryan on 09/08/2024.
//

import SwiftUI
import EventKit

struct SingleEventModelView: View {
    @Binding  var event: EKEvent

    var body: some View {
        NavigationView {
            Text(event.notes ?? "Aucune note")
        }
  
    }
}

#Preview {
    SingleEventModelView(event: .constant(EKEvent(eventStore: EKEventStore())))

}



