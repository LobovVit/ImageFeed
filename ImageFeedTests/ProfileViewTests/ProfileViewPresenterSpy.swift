//
//  ProfileViewPresenterSpy.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 16.12.2024.
//
@testable import ImageFeed

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var notificationObserverCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func notificationObserver() {
        notificationObserverCalled = true
    }
    
    func updateAvatar() {
    }
}
