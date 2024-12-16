//
//  ProfileViewControllerSpy.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 16.12.2024.
//
@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    
    func updateAvatar() {
    }
    
    func displayProfileData(name: String?, loginName: String?, bio: String?) {
    }
}
