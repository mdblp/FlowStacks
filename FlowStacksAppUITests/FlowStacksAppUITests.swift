//
//  FlowStacksAppUITests.swift
//  FlowStacksAppUITests
//
//  Created by Renaud Pradenc on 15/07/2022.
//

import XCTest

/// Visual structure of the application
fileprivate struct AppPage {
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

/// Visual structure of the root view of the "Parent" tab
fileprivate struct ParentRootPage {
    let app: XCUIApplication

    var isOnThisPage: Bool {
        flow1Button.exists && flow2Button.exists
    }

    var flow1Button: XCUIElement {
        app.buttons["Go to flow one"]
    }

    func goToFlow1Page() -> Flow1Page {
        flow1Button.tap()
        return Flow1Page(app: app)
    }

    var flow2Button: XCUIElement {
        app.buttons["Go to flow two"]
    }
}

/// Visual structure of the "Flow 1" view
fileprivate struct Flow1Page {
    let app: XCUIApplication

    var titleLabel: XCUIElement {
        app.staticTexts["Flow 1: Flow's First Step"]
    }
    var isOnThisPage: Bool {
        titleLabel.exists
    }

    var flow2Button: XCUIElement {
        app.buttons["Go to flow's second view"]
    }

    func goToFlow2() -> Flow2Page {
        flow2Button.tap()
        return Flow2Page(app: app)
    }

    var closeButton: XCUIElement {
        app.buttons["ChildFlowFirstView.closeButton"]
    }
}

/// Visual structure of the "Flow 2" view, when presented after the "Flow 1" view
fileprivate struct Flow2Page {
    let app: XCUIApplication

    var titleLabel: XCUIElement {
        app.staticTexts["Flow 1: Flow's Second Step"]
    }
    var isOnThisPage: Bool {
        titleLabel.exists
    }

    var backButton: XCUIElement {
        app.buttons["Go back to start of flow"]
    }

    var closeButton: XCUIElement {
        app.buttons["ChildFlowSecondView.closeButton"]
    }
}

class FlowStacksAppUITests: XCTestCase {
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

    /// Push one screen "over" then come back
    func testPresentsThenClosesFlow1() {
        // Present the Flow 1 page
        let appPage = AppPage(app: app)
        let parentPage = appPage.goToParentTab()
        let flow1Button = parentPage.flow1Button
        XCTAssertTrue(flow1Button.exists)

        let flow1Page = parentPage.goToFlow1Page()
        XCTAssertTrue(flow1Page.isOnThisPage)

        // Close it
        let closeButton = flow1Page.closeButton
        XCTAssertTrue(closeButton.exists)
        closeButton.tap()

        // Check that we're back on the Parent page
        XCTAssertTrue(parentPage.isOnThisPage)
    }

    /// Push two screens "over", then go back to the root
    func testPresentsFlow2OverFlow1() {
        // Present the Flow 1 page
        let appPage = AppPage(app: app)
        let parentPage = appPage.goToParentTab()
        let flow1Page = parentPage.goToFlow1Page()

        // Present the Flow 2 page over it
        let flow2Page = flow1Page.goToFlow2()
        XCTAssertTrue(flow2Page.isOnThisPage)

        // Close it
        let closeButton = flow2Page.closeButton
        XCTAssertTrue(closeButton.exists)
        closeButton.tap()

        // Check that we're back to the root of the tab
        XCTAssertTrue(parentPage.isOnThisPage)
    }
}
