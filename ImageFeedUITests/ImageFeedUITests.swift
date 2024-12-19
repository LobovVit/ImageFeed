//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Vitaly Lobov on 27.09.2024.
//

import XCTest

final class Image_FeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    private enum Const {
        static let loginText: String = "lobov.vitaliy@gmail.com"
        static let passwordText: String = "QWEdsa123"
        static let name:  String = "Vitalii Lobov"
        static let username:  String = "@lovital"
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText(Const.loginText)
        app.toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText(Const.passwordText)
        app.toolbars.buttons["Done"].tap()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 3))
        cell.swipeUp()
        sleep(4)
        app.swipeDown()
        sleep(4)
        app.swipeDown()
        sleep(4)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 0)
        forceTapElement(element: cellToLike.buttons["LikeButton"])
        sleep(10)
        forceTapElement(element: cellToLike.buttons["LikeButton"])
        sleep(10)
        
        forceTapElement(element: cellToLike)
        sleep(10)
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let backButton = app.buttons["BackButton"]
        backButton.tap()
    }
    
    func testProfile() throws {
        XCTAssertTrue(app.tabBars.buttons.element(boundBy: 0).waitForExistence(timeout: 3))
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts[Const.name].exists)
        XCTAssertTrue(app.staticTexts[Const.username].exists)
        
        app.buttons["ExitButton"].tap()
        app.alerts["Выход"].scrollViews.otherElements.buttons["Да"].tap()
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 3))
    }
    
    func forceTapElement(element: XCUIElement) {
            if element.isHittable {
                element.tap()
            }
            else {
                let coordinate: XCUICoordinate = element.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).withOffset(CGVector(dx: element.frame.origin.x, dy: element.frame.origin.y))
                coordinate.tap()
            }
        }
}

