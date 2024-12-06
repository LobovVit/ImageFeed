//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 15.11.2024.
//
import Foundation

enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    
    static let shared = ProfileService()
    private init() {}
    
    private let decoder = JSONDecoder()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let request = makeProfileRequest(code: token) else {
            print("ERR: invalid request")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        let task = decode(for: request) { [weak self] result in
            guard let self else {
                print("ERR: decode error")
                return
            }
            print(result)
            switch result {
            case .success(let body):
                self.profile = Profile(
                    username: body.username,
                    firstName: body.firstName,
                    lastName: body.lastName ?? "",
                    bio: body.bio ?? "")
                guard let profile = self.profile else { return }
                completion(.success(profile))
            case .failure(let error):
                print("ERR: decode failure  \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func makeProfileRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://api.unsplash.com") else {
            print("ERR: invalid base URL")
            return nil
        }
        guard let url = URL(
            string: "/me",
            relativeTo: baseURL
        ) else {
            print("ERR: building URL from base URL")
            return nil
        }
        var request = URLRequest(url: url)
        let bearerToken = "Bearer " + code
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    private func decode(
        for request: URLRequest,
        completion: @escaping(Result<ProfileResult, Error>) -> Void
    ) -> URLSessionTask {
        return urlSession.data(for: request) { [weak self] (result: Result<Data, Error>) in
            guard let self else { return }
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result {
                    try self.decoder.decode(ProfileResult.self, from: data)
                }
            }
            completion(response)
        }
    }
    
}
