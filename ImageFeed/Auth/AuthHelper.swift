//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 16.12.2024.
//
import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest? {
        guard let url = authURL() else { return nil}
        return URLRequest(url: url)
    }
    
    func authURL() -> URL? {
        guard var urlComponents = URLComponents(string: configuration.unsplashAuthorizeURLString) else { return nil}
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: Constants.code),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        return urlComponents.url
    }
    
    func code(url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path ==  Constants.authorizeNative ,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == Constants.code })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    
}
