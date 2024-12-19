//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 01.11.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    
    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print("ERR: Network - HTTP Status code: \(statusCode).")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("ERR: Network - URL Request: \(error.localizedDescription).")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("ERR: Network - URL session error.")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping(Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let responseData):
                do {
                    let decodedData = try decoder.decode(T.self, from: responseData)
                    completion(.success(decodedData))
                } catch {
                    print("ERR: Decoder - \(error.localizedDescription), Data: \(String(data: responseData, encoding: .utf8) ?? "Empty")")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("ERR: Network = \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        return task
    }
}
