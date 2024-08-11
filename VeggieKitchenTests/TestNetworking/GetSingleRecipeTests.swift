//
//  GetSingleRecipeTests.swift
//  VeggieKitchenTests
//
//  Created by julie ryan on 01/08/2024.
//

import XCTest
import Combine
@testable import VeggieKitchen

class GetSingleRecipeTests: XCTestCase {
    
    
    func givenFetchRecipeDetailsFails_whenFetchingRecipeDetails_thenErrorMessageIsReturned() throws {
 
        let expectation = self.expectation(description: "Fetch recipe details failure")
        let mockError = NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockRecipesService = MockRecipesService(mockError: mockError)
        getSingleRecipe = GetSingleRecipe(recipeService: mockRecipesService)


        getSingleRecipe.fetchRecipeDetails(recipeId: 1)

    
        getSingleRecipe.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "Test error")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
        XCTAssertFalse(getSingleRecipe.isLoading)
        XCTAssertNil(getSingleRecipe.recipe)
    }

    func givenFetchRecipeDetailsSucceeds_whenFetchingRecipeDetails_thenRecipeDetailsAreFetchedSuccessfully() throws {
    
        let expectation = self.expectation(description: "Fetch recipe details")
        let mockRecipe = Recipe(extendedIngredients: [Ingredient(id: 3, original: "tomato ")], id: 1, title: "title", readyInMinutes: 5, image: "sample", imageType: "jpg", instructions: "instructions")
        let mockData = try JSONEncoder().encode(mockRecipe)
        mockRecipesService = MockRecipesService(mockData: mockData)
        getSingleRecipe = GetSingleRecipe(recipeService: mockRecipesService)


        getSingleRecipe.fetchRecipeDetails(recipeId: 1)

 
        getSingleRecipe.$recipe
            .dropFirst()
            .sink { recipe in
                XCTAssertEqual(recipe?.id, 1)
                XCTAssertEqual(recipe?.title, "title")
                XCTAssertEqual(recipe?.image, "sample")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
        XCTAssertFalse(getSingleRecipe.isLoading)
        XCTAssertNil(getSingleRecipe.errorMessage)
    }
    
    
    var getSingleRecipe: GetSingleRecipe!
    var mockRecipesService: MockRecipesService!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        getSingleRecipe = nil
        mockRecipesService = nil
        cancellables = nil
        try super.tearDownWithError()
    }




}
