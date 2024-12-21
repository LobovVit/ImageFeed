//
//  ImagesListViewControllerTests.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 16.12.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewControllerTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //Given
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        presenter.view = viewController
        viewController.presenter = presenter
        //When
        presenter.viewDidLoad()
        //Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerCallsNotificationObserver() {
        //Given
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        //When
        presenter.notificationObserver()
        //Then
        XCTAssertTrue(presenter.notificationObserverCalled)
    }
    
    func testUpdateTableViewAnimated() {
        //Given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenterSpy()
        presenter.view = viewController
        viewController.presenter = presenter
        //When
        viewController.updateTableViewAnimated()
        //Then
        XCTAssertTrue(viewController.tableViewUpdatesCalled)
    }
    
    func testChangeLike() {
        //Given
        let expectation = XCTestExpectation(description: "Change like")
        let presenter = ImagesListViewPresenterSpy()
        //When
        presenter.changeLike(photoId: "PhotoId", isLiked: true) { _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        //Then
        XCTAssertTrue(presenter.isLiked)
    }
}

