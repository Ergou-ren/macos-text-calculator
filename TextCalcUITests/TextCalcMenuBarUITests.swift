import XCTest

final class TextCalcMenuBarUITests: XCTestCase {
    func testLaunchShowsMainCalculatorSurface() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-ui-testing")
        app.launch()

        let statusItem = app.statusItems["sum"]
        XCTAssertTrue(statusItem.waitForExistence(timeout: 5))
        statusItem.click()

        let title = app.staticTexts["appTitle"]
        XCTAssertTrue(title.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["hotkeyStatus"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.textFields["inputField"].waitForExistence(timeout: 5))
    }

    func testCalculateFlowShowsResult() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-ui-testing")
        app.launch()

        let statusItem = app.statusItems["sum"]
        XCTAssertTrue(statusItem.waitForExistence(timeout: 5))
        statusItem.click()

        let input = app.textFields["inputField"]
        XCTAssertTrue(input.waitForExistence(timeout: 5))
        input.click()
        input.typeText("1 2 3 4 5 6 7 这几个数字求和")
        app.buttons["calculateButton"].click()

        XCTAssertTrue(app.staticTexts["resultText"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.staticTexts["resultText"].label, "28")
    }
}
