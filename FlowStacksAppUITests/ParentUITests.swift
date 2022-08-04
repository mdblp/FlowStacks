import XCTest

/// Visual structure of the root view of the "Parent" tab
struct ParentRootPage {
    let app: XCUIApplication

    func waitIsOnThisPage(timeout: TimeInterval) -> Bool {
        // Hittable only if the modal is foremost
        flow1Button.waitForHittable(timeout: timeout)
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
struct Flow1Page {
    let app: XCUIApplication

    var titleLabel: XCUIElement {
        app.staticTexts["Flow 1: Flow's First Step"]
    }
    var isOnThisPage: Bool {
        // Hittable only if the modal is foremost
        closeButton.exists && closeButton.isHittable
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
struct Flow2Page {
    let app: XCUIApplication

    var titleLabel: XCUIElement {
        app.staticTexts["Flow 1: Flow's Second Step"]
    }
    var isOnThisPage: Bool {
        // Hittable only if the modal is foremost
        closeButton.exists && closeButton.isHittable
    }

    var backButton: XCUIElement {
        app.buttons["Go back to start of flow"]
    }

    var closeButton: XCUIElement {
        app.buttons["ChildFlowSecondView.closeButton"]
    }
}


class ParentUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
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
        XCTAssertTrue(parentPage.waitIsOnThisPage(timeout: 2.0))
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
        XCTAssertTrue(parentPage.waitIsOnThisPage(timeout: 2.0))
    }
}
