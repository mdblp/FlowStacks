//
//  FlowStacksAppUITests.swift
//  FlowStacksAppUITests
//
//  Created by Renaud Pradenc on 15/07/2022.
//

import XCTest

class FlowStacksAppUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testPresentsTabsAtLaunch() {
        XCTAssertTrue(app.tabBars["Tab Bar"].exists)
        XCTAssertTrue(app.tabBars.buttons["Parent"].exists)
        XCTAssertTrue(app.tabBars.buttons["Numbers"].exists)
        XCTAssertTrue(app.tabBars.buttons["VMs"].exists)
        XCTAssertTrue(app.tabBars.buttons["Binding"].exists)
        XCTAssertTrue(app.tabBars.buttons["Showing"].exists)
    }
}
