//
//  ProfileStorage.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 15.11.2024.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile {
    var username: String
    var firstName: String
    var lastName: String
    
    var name: String {
        let fullName = "\(firstName) \(lastName)"
        return fullName
    }
    
    var loginName: String {
        let loginName = "@\(username)"
        return loginName
    }
    
    var bio: String
}

struct UserResult: Codable {
    let profileImage: image
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct image: Codable {
    let small: String
}
