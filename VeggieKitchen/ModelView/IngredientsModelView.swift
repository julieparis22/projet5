//
//  IngredientsModelView.swift
//  VeggieKitchen
//
//  Created by julie ryan on 01/08/2024.
//

import SwiftUI

struct IngredientsModelView: View {
    @Binding var ingredient: Ingredient
    var body: some View {
        VStack(alignment: .leading) {
            Text(ingredient.original)
                       .font(.body)
                       .padding(2)
                       .lineLimit(nil)
                       .fixedSize(horizontal: false, vertical: true)
               }
               .padding(.horizontal, 16)

      
    }
}


#Preview {
    IngredientsModelView(ingredient: .constant(Ingredient(id: 22, original: "banana")))
}
