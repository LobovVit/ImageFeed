//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 30.10.2024.
//
import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()
    private var task: URLSessionTask?
    private var lastCode: String?
    private var authToken: String?
    {
        get {
            return OAuth2TokenStorage.shared.token
        }
        set {
            OAuth2TokenStorage.shared.token = newValue
        }
    }
    
    private init() {}
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            print("ERR: invalid base URL")
            return nil
        }
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            print("ERR: building URL from base URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    private func decode(
        for request: URLRequest,
        completion: @escaping(Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result {
                    try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
                }
            }
            completion(response)
        }
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("ERR: invalid request")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        let task = decode(for: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else {
                    print("ERR: decode error")
                    return
                }
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(authToken))
                case .failure(let error):
                    completion(.failure(error))
                }
                self.task = nil
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}
