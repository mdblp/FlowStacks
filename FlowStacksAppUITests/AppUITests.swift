//
//  FlowStacksAppUITests.swift
//  FlowStacksAppUITests
//
//  Created by Renaud Pradenc on 15/07/2022.
//

import XCTest

/// Visual structure of the application
struct AppPage {
    let app: XCUIApplication

    var tabBar: XCUIElement {
        app.tabBars["Tab Bar"]
    }

    var parentTab: XCUIElement {
        app.tabBars.buttons["Parent"]
    }
    
    func goToParentTab() -> ParentRootPage {
        parentTab.tap()
        return ParentRootPage(app: app)
    }

    var numbersTab: XCUIElement {
        app.tabBars.buttons["Numbers"]
    }

    var VMsTab: XCUIElement {
        app.tabBars.buttons["VMs"]
    }

    var bindingTab: XCUIElement {
        app.tabBars.buttons["Binding"]
    }

    var showingTab: XCUIElement {
        app.tabBars.buttons["Showing"]
    }
}


class AppUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    /// Check whether a TabBar with all the expected tabs is presented
    func testPresentsTabsAtLaunch() {
        let appPage = AppPage(app: app)
        XCTAssertTrue(appPage.tabBar.exists)
        XCTAssertTrue(appPage.parentTab.exists)
        XCTAssertTrue(appPage.numbersTab.exists)
        XCTAssertTrue(appPage.VMsTab.exists)
        XCTAssertTrue(appPage.bindingTab.exists)
        XCTAssertTrue(appPage.showingTab.exists)
    }
}
