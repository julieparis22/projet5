//
//  CalendarAcessView.swift
//  VeggieKitchen
//
//  Created by julie ryan on 10/08/2024.
//

import SwiftUI
import EventKit
struct CalendarAccessView: View {
    @StateObject private var calendarManager = CalendarManager()
    @State private var authorizationStatus: EKAuthorizationStatus = .notDetermined
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            switch authorizationStatus {
            case .notDetermined:
                Button("Grant access to your personal Calendar") {
                    requestAccess()
                }
            case .restricted:
                Text("Calendar access is restricted.")
            case .denied:
                VStack {
                    Text("Calendar access has been denied.")
                    Text("Please enable it in your iPhone settings.")
                }
            case .authorized, .fullAccess:
                Text("Calendar access granted!")
            case .writeOnly:
                Text("Calendar write-only access granted!")
            @unknown default:
                Text("Unknown authorization status.")
            }
            
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .onAppear {
            updateAuthorizationStatus()
        }
    }
    
    private func updateAuthorizationStatus() {
        authorizationStatus = calendarManager.checkCalendarAuthorizationStatus()
    }
    
    private func requestAccess() {
        calendarManager.requestCalendarAccess { granted, error in
            if granted {
                authorizationStatus = calendarManager.checkCalendarAuthorizationStatus()
            } else {
                errorMessage = error?.localizedDescription ?? "Error requesting access."
            }
            updateAuthorizationStatus()
        }
    }
}

#Preview {
    CalendarAccessView()
}
