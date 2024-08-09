//
//  TestView.swift
//  VeggieKitchen
//
//  Created by julie ryan on 09/08/2024.
//

import SwiftUI

struct TestView: View {
    let recipeService = RealRecipesService()
    var body: some View {
        RecipesListView(recipeService: recipeService)
    }
}

#Preview {
    TestView()
}
