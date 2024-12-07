//
//  Photos.swift
//  ImageFeed
//
//  Created by Vitaly Lobov on 06.12.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    let thumbSize: CGSize
}

struct PhotoResult: Codable {
    let id: String
    let width, height: Int
    let createdAt: String?
    let description: String?
    let likedByUser: Bool
    let urls: Urls
}

struct Urls: Codable {
    let full: String
    let small: String
}

struct LikeResult: Codable {
    let photo: PhotoLikeResult
}

struct PhotoLikeResult: Codable {
    let likedByUser: Bool
}
