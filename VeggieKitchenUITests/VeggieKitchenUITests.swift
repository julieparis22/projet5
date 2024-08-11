//
//  VeggieKitchenUITests.swift
//  VeggieKitchenUITests
//
//  Created by julie ryan on 06/08/2024.
//

import XCTest

final class VeggieKitchenUITests: XCTestCase {

    override func setUpWithError() throws {
          continueAfterFailure = false
      }

      override func tearDownWithError() throws {
          // Code de nettoyage si nécessaire
      }

      func testExample() throws {
          let app = XCUIApplication()
          app.launch()

          // Ajouter des assertions ou interactions avec l'interface utilisateur ici
      }


      func testLaunchPerformance() throws {
          if #available(iOS 13.0, *) {
              measure(metrics: [XCTApplicationLaunchMetric()]) {
                  let app = XCUIApplication()
                  app.launch()
              }
          }
      }
}
