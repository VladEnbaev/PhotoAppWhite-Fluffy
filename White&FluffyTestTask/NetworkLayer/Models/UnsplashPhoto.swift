//
//  UnsplashPhoto.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 14.06.2023.
//

import Foundation

struct SearchResults: Decodable {
    let total: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Codable {
    let id: String
    let createdAt: String?
    let width, height: Int
    let downloads: Int?
    let likedByUser: Bool
    let description: String?
    
    let location: Location?
    let urls: Urls
    let user: UnsplashUser

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height, downloads
        case likedByUser = "liked_by_user"
        case description, location, urls, user
    }
    
    struct Urls : Codable {
        let raw, full, thumb, small: String?
        let regular: String
    }

    struct Location: Codable {
        let name: String?
        let position: Position
    }

    struct Position : Codable {
        let latitude, longitude: Double?
    }

}
