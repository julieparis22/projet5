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
    @State private var isRequestingAccess = false
    var onAccessGranted: () -> Void
    
    var body: some View {
        VStack {
            switch authorizationStatus {
            case .notDetermined:
                Button(action: requestAccess) {
                    Text("Grant access to your personal Calendar")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isRequestingAccess)
            case .restricted:
                Text("Calendar access is restricted.")
                    .foregroundColor(.orange)
            case .denied:
                VStack {
                    Text("Calendar access has been denied.")
                    Text("Please enable it in your iPhone settings.")
                    Button("Open Settings") {
                        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsUrl)
                        }
                    }
                    .padding()
                }
            case .fullAccess:
                Text("Full calendar access granted!")
                    .foregroundColor(.green)
            case .writeOnly:
                Text("Calendar write-only access granted!")
                    .foregroundColor(.yellow)
            @unknown default:
                Text("Unknown authorization status.")
                    .foregroundColor(.red)
            }
            
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            if isRequestingAccess {
                ProgressView()
                    .padding()
            }
        }
        .padding()
        .onAppear(perform: updateAuthorizationStatus)
    }
    
    private func updateAuthorizationStatus() {
        authorizationStatus = calendarManager.checkCalendarAuthorizationStatus()
        if authorizationStatus == .fullAccess || authorizationStatus == .writeOnly {
            onAccessGranted()
        }
    }
    
    private func requestAccess() {
        isRequestingAccess = true
        calendarManager.requestCalendarAccess { granted, error in
            isRequestingAccess = false
            if granted {
                authorizationStatus = calendarManager.checkCalendarAuthorizationStatus()
                if authorizationStatus == .fullAccess || authorizationStatus == .writeOnly {
                    onAccessGranted()
                }
            } else {
                errorMessage = error?.localizedDescription ?? "Error requesting access."
            }
            updateAuthorizationStatus()
        }
    }
}

#Preview {
    CalendarAccessView(onAccessGranted: {
        print("Access granted in preview")
    })
}
