//
//  ProfileViewTests.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 16.12.2024.
//
@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {

        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        presenter.viewDidLoad()

        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerCallsNotificationObserver() {
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.notificationObserver()
        
        XCTAssertTrue(presenter.notificationObserverCalled)
    }
}
