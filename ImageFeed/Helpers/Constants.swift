//
//  Constants.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 26.10.2024.
//

import Foundation

enum Constants {
    static let accessKey: String = "ad5B2R4PRpaMHhxwD052WrPmzYgeMFR6xgSZbBvQ2Ok"
    static let secretKey: String = "lHNGEY7Et8sTaDX7WNi_an1uY3tYdO7EfRGwF3ojiyU"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let authorizeNative = "/oauth/authorize/native"
    static let code = "code"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}


