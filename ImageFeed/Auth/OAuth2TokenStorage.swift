//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 01.11.2024.
//

import Foundation
import SwiftKeychainWrapper


final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "BearerToken"
    
    var token: String? {
        get {
            let token: String? = KeychainWrapper.standard.string(forKey: tokenKey)
            guard let token else { return nil }
            return token
        }
        
        set {
            guard let newValue else { return }
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: tokenKey)
            guard isSuccess else {
                print("ERR: Failed to save token to keychain")
                return
            }
        }
    }
    
    private init() {}
    
    func removeToken() -> Bool {
        KeychainWrapper.standard.removeObject(forKey: tokenKey)
    }
    
}
