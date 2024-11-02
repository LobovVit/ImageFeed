//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 01.11.2024.
//

import Foundation


final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "BearerToken"
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
    
    private init() {}
}
