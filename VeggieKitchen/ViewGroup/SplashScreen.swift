//
//  SplashView.swift
//  VeggieKitchen
//
//  Created by julie ryan on 11/08/2024.
//

import SwiftUI

struct SplashScreen: View {
    @State var showSplashcreen = true
    var heigthSize = UIScreen.main.bounds.height / 3
    var body: some View {
        if showSplashcreen {
            ZStack {
                Color("backScreenColor")
                VStack {
                    Spacer()
                    Text("Veggie Kitchen Demo App").font(.title)
                    ScrollView {
                        Text("This is a demo application: it retrieves a list of vegetarian recipes from Spoonacular (recipes that sometimes include meat when moderation has not yet been completed) and allows the user to add them to a meal recipe,  that can be accessed offline. The meals are arranged in chronological order. The application also includes tests and specially network tests. The App is in English since it's for a portfolio. The user must grant access to their calendar as the first step.")
                    }
                    Spacer()
                    Button("TRY DEMO APP") {
                        showSplashcreen = false
                    }.padding()
                        .font(.largeTitle)
                    
                    Image(systemName: "book.and.wrench").resizable().scaledToFit()
                 
                    Spacer()
                   
                    Spacer()
                
              
                    Spacer()
                }
            }
         


        }else {
           MainTabView()
        }
    }
}

#Preview {
    SplashScreen()
}
