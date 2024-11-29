//
//  NetErr.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 19.11.2024.
//

func netErr(_ error: Error) {
    if let networkError = error as? NetworkError {
        switch networkError {
        case .httpStatusCode(let statusCode):
            print("Received HTTP error with status code: \(statusCode)")
        case .urlRequestError(let requestError):
            print("URL Request error occurred: \(requestError.localizedDescription)")
        case .urlSessionError:
            print("An unknown URLSession error occurred.")
        }
    } else {
        print("An unknown error occurred: \(error.localizedDescription)")
    }
}
