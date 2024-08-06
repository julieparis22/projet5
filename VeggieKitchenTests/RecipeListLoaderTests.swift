//
//  RecipeListLoaderTests.swift
//  VeggieKitchenTests
//
//  Created by julie ryan on 31/07/2024.
//

import XCTest
import Combine
@testable import VeggieKitchen

final class RecipeListTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    func GivenSuccessfulResponse_WhenFetchingRecipes_ThenRecipesAreLoadedCorrectly() {
        // Given
        let mockData = """
        {
            "results": [
                {
                    "id": 715415,
                    "title": "Red Lentil Soup with Chicken and Turnips",
                    "image": "https://img.spoonacular.com/recipes/715415-312x231.jpg",
                    "imageType": "jpg"
                },
                {
                    "id": 716406,
                    "title": "Asparagus and Pea Soup: Real Convenience Food",
                    "image": "https://img.spoonacular.com/recipes/716406-312x231.jpg",
                    "imageType": "jpg"
                }
            ],
            "offset": 0,
            "number": 2,
            "totalResults": 5233
        }
        """.data(using: .utf8)!
        
        let mockService = MockRecipesService(mockData: mockData)
        let loader = RecipeListLoader(recipeService: mockService)
        
        let expectation = XCTestExpectation(description: "Fetch recipes")
        
        // When
        loader.fetchRecipes()
        
        // Then
        loader.$recipes
            .dropFirst() // Skip the initial empty state
            .sink(receiveValue: { recipes in
                XCTAssertEqual(recipes.count, 2)
                XCTAssertEqual(recipes[0].title, "Red Lentil Soup with Chicken and Turnips")
                XCTAssertEqual(recipes[1].title, "Asparagus and Pea Soup: Real Convenience Food")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(loader.isLoading)
        XCTAssertNil(loader.error)
    }

    func GivenErrorResponse_WhenFetchingRecipes_ThenErrorIsHandledCorrectly() {
        // Given
        let mockError = NSError(domain: "TestError", code: 0, userInfo: nil)
        let mockService = MockRecipesService(mockError: mockError)
        let loader = RecipeListLoader(recipeService: mockService)
        
        let expectation = XCTestExpectation(description: "Fetch recipes error")
        
        // When
        loader.fetchRecipes()
        
        // Then
        loader.$error
            .dropFirst()
            .sink(receiveValue: { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(loader.isLoading)
        XCTAssertTrue(loader.recipes.isEmpty)
    }
}

