//
//  NumbersUITests.swift
//  FlowStacksAppUITests
//
//  Created by Renaud Pradenc on 02/08/2022.
//

import XCTest


/// Visual structure of the "Numbers" view
struct NumbersPage {
    let app: XCUIApplication

    /// The number expected to be set in the stepper
    ///
    /// We have a problem identifying the view and therefore its child controls within tests.
    /// The trick employed here is having the controls with accessibilityIdentifier's of
    /// the form `Control\(number)`, so we can reference them.
    /// A drawback is that each time that this number changes, we must create a new
    /// `NumbersPage` with a  `pageNumber` matching the expected view's `number`.
    let pageNumber: Int

    func waitIsOnThisPage(timeout: TimeInterval) -> Bool {
        // Hittable only if the modal is foremost
        coverButton.waitForHittable(timeout: timeout)
    }

    var stepper:  XCUIElement {
        app.steppers["Stepper\(pageNumber)"]
    }

    /// The integer value of the stepper
    var stepperNumber: Int? {
        guard let stringValue = stepper.value as? String else {
            return nil
        }
        return Int(stringValue)
    }

    var decrementButton: XCUIElement {
        stepper
            .descendants(matching: .button)
            .matching(identifier: "Decrement")
            .firstMatch
    }

    func decrement() -> NumbersPage {
        decrementButton.tap()
        return NumbersPage(app: app, pageNumber: pageNumber-1)
    }

    var incrementButton: XCUIElement {
        stepper
            .descendants(matching: .button)
            .matching(identifier: "Increment")
            .firstMatch
    }

    func increment() -> NumbersPage {
        incrementButton.tap()
        return NumbersPage(app: app, pageNumber: pageNumber+1)
    }

    var coverButton: XCUIElement {
        app.buttons["CoverButton\(pageNumber)"]
    }

    func presentDoubleCovering() -> NumbersPage {
        coverButton.tap()
        return NumbersPage(app: app, pageNumber: pageNumber * 2)
    }

    var sheetButton: XCUIElement {
        app.buttons["SheetButton\(pageNumber)"]
    }

    func presentDoubleAsSheet() -> NumbersPage {
        sheetButton.tap()
        return NumbersPage(app: app, pageNumber: pageNumber * 2)
    }

    var pushNextButton: XCUIElement {
        app.buttons["PushButton\(pageNumber)"]
    }

    func pushIncrementing() -> NumbersPage {
        pushNextButton.tap()
        let _ = stepper.waitForExistence(timeout: 1.0) // Needed to wait for the push action :-(
        return NumbersPage(app: app, pageNumber: pageNumber + 1)
    }

    var rootButton: XCUIElement {
        app.buttons["RootButton\(pageNumber)"]
    }

    func goBackToRoot(newPageNumber: Int) -> NumbersPage {
        rootButton.tap()
        return NumbersPage(app: app, pageNumber: newPageNumber)
    }
}

class NumbersUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testPresents0AtFirst() {
        let appPage = AppPage(app: app)
        let numbersPage = appPage.goToNumbersTab()
        XCTAssertEqual(numbersPage.stepperNumber, 0)
    }

    func testIncrementing() {
        let appPage = AppPage(app: app)
        let page0 = appPage.goToNumbersTab()
        XCTAssertEqual(page0.stepperNumber, 0)

        let page1 = page0.increment()
        let page2 = page1.increment()
        XCTAssertEqual(page2.stepperNumber, 2)
    }

    func testDecrementing() {
        let appPage = AppPage(app: app)
        let page0 = appPage.goToNumbersTab()
        XCTAssertEqual(page0.stepperNumber, 0)

        let pageM1 = page0.decrement()
        let pageM2 = pageM1.decrement()
        XCTAssertEqual(pageM2.stepperNumber, -2)
    }

    func testPushing() {
        let appPage = AppPage(app: app)
        let page0 = appPage.goToNumbersTab()
        XCTAssertEqual(page0.stepperNumber, 0)

        let page1 = page0.pushIncrementing()
        XCTAssertEqual(page1.stepperNumber, 1)
    }

    func testCovering() {
        let appPage = AppPage(app: app)
        let page0 = appPage.goToNumbersTab()
        XCTAssertEqual(page0.stepperNumber, 0)

        let page1 = page0.pushIncrementing()
        XCTAssertEqual(page1.stepperNumber, 1)

        let page2 = page1.presentDoubleCovering()
        XCTAssertEqual(page2.stepperNumber, 2)

        let page4 = page2.presentDoubleCovering()
        XCTAssertEqual(page4.stepperNumber, 4)
    }

    func testPresentingAsSheet() {
        // The Numbers tab presents "0" at first
        let appPage = AppPage(app: app)
        let page0 = appPage.goToNumbersTab()
        XCTAssertEqual(page0.stepperNumber, 0)

        let pageM1 = page0.decrement()
        XCTAssertEqual(pageM1.stepperNumber, -1)

        let pageM2 = pageM1.presentDoubleAsSheet()
        XCTAssertEqual(pageM2.stepperNumber, -2)
    }

    func testGoesBackToRootOfComplexHierarchy() {
        let appPage = AppPage(app: app)
        let page0 = appPage.goToNumbersTab()
        XCTAssertEqual(page0.stepperNumber, 0)

        let page1 = page0.pushIncrementing()
        XCTAssertEqual(page1.stepperNumber, 1)

        let page2 = page1.presentDoubleAsSheet()
        XCTAssertEqual(page2.stepperNumber, 2)

        let page4 = page2.presentDoubleCovering()
        XCTAssertEqual(page4.stepperNumber, 4)

        let page3 = page4.decrement()
        XCTAssertEqual(page3.stepperNumber, 3)

        let page6 = page3.presentDoubleAsSheet()
        XCTAssertEqual(page6.stepperNumber, 6)

        let page7 = page6.pushIncrementing()
        XCTAssertEqual(page7.stepperNumber, 7)

        let page14 = page7.presentDoubleAsSheet()
        XCTAssertEqual(page14.stepperNumber, 14)

        // Go back to root
        let pageBack = page14.goBackToRoot(newPageNumber: 0)
        XCTAssertTrue(pageBack.waitIsOnThisPage(timeout: 4.0))
        XCTAssertEqual(pageBack.stepperNumber, 0)
    }
}
