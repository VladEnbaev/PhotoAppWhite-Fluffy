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
    let createdAt : String?
    let width, height: Int
    let downloads: Int?
    let description: String?
    
    let urls : Urls
    let user : UnsplashUser
}

struct Urls : Codable{
    let raw, full, regular, small: String
    let thumb: String
}

struct Location: Codable {
    let name, city, country: String
    let position: Position
}

struct Position : Codable {
    let latitude, longitude: Double
}
