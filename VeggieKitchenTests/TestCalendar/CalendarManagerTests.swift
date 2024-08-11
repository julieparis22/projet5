//
//  CalendarManagerTests.swift
//  VeggieKitchenTests
//
//  Created by julie ryan on 07/08/2024.
//

import XCTest
import EventKit
@testable import VeggieKitchen

class CalendarManagerTests: XCTestCase {
    
    var calendarManager: CalendarManager!
    
    func givenAcessAsked_WhenAccepted_thenGiveAccess() {
        let expectation = self.expectation(description: "Calendar access request")
        
        calendarManager.requestCalendarAccess { granted, error in
            XCTAssertTrue(granted, "Calendar access should be granted")
            XCTAssertNil(error, "There should be no error")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func GivenNoEvent_WhenEventCreated_ThenAddEvent() {
        let expectation = self.expectation(description: "Add event to calendar")
        
        let title = "Test Event"
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(3600)
        let instructions = "Test instructions"
        
        calendarManager.addEventToCalendar(title: title, startDate: startDate, endDate: endDate, instructions: instructions, ingredients: [IngredientMeal(original: "tomato")]) { success, error in
            XCTAssertTrue(success, "Event should be added successfully")
            XCTAssertNil(error, "There should be no error")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func GivenExpectation_WhenFetchEvents_ThenGiveEvents() {
        let expectation = self.expectation(description: "Fetch events")
        
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(86400) // 1 day later
        
        calendarManager.fetchEvents(startDate: startDate, endDate: endDate) { events, error in
            XCTAssertNotNil(events, "Events should not be nil")
            XCTAssertNil(error, "There should be no error")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func GivenExpectation_WhenAskedToDelete_ThenDeleteEvent() {
        let expectation = self.expectation(description: "Delete event")
        
        // First, add an event
        let title = "Event to Delete"
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(3600)
        let instructions = "This event will be deleted"
        
        calendarManager.addEventToCalendar(title: title, startDate: startDate, endDate: endDate, instructions: instructions, ingredients: [IngredientMeal(original: "tomato")]) { success, error in
            XCTAssertTrue(success, "Event should be added successfully")
            
            // Now, fetch the event
            self.calendarManager.fetchEvents(startDate: startDate, endDate: endDate) { events, fetchError in
                XCTAssertNotNil(events, "Events should not be nil")
                XCTAssertNil(fetchError, "There should be no fetch error")
                
                if let eventToDelete = events?.first(where: { $0.title == title }) {
                    // Delete the event
                    self.calendarManager.deleteEvent(eventToDelete) { deleteSuccess, deleteError in
                        XCTAssertTrue(deleteSuccess, "Event should be deleted successfully")
                        XCTAssertNil(deleteError, "There should be no delete error")
                        expectation.fulfill()
                    }
                } else {
                    XCTFail("Could not find the event to delete")
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        calendarManager = CalendarManager()
    }
    
    override func tearDownWithError() throws {
        calendarManager = nil
        try super.tearDownWithError()
    }
}
