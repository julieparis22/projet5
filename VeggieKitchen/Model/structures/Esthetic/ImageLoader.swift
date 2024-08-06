//
//  ImageLoader.swift
//  VeggieKitchen
//
//  Created by julie ryan on 05/08/2024.
//

import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: Image?
    private var cancellable: AnyCancellable?
    
    init(urlString: String) {
        loadImage(from: urlString)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
       
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .map { UIImage(data: $0) }
            .map { Image(uiImage: $0 ?? UIImage()) }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] image in
             
                self?.image = image
            })
    }
    
    private var cancellables = Set<AnyCancellable>()
}
