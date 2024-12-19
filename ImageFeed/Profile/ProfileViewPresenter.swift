//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 16.12.2024.
//

import Foundation

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func notificationObserver()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(view: ProfileViewControllerProtocol) {
        self.view = view
        notificationObserver()
    }
    
    func viewDidLoad() {
        notificationObserver()
        view?.displayProfileData(name: ProfileService.shared.profile?.name, loginName: ProfileService.shared.profile?.loginName, bio: ProfileService.shared.profile?.bio)
    }
    
    func notificationObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.view?.updateAvatar()
            }
    }
}
