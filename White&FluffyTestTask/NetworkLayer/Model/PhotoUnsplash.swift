//
//  UnsplashPhoto.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 14.06.2023.
//

import Foundation

struct PhotoUnsplash: Codable {
    let id: String
    let createdAt : Date
    let width, height: Int
    let downloads: Int
    let description: String
    
    let user : UserUnsplash
}

struct Location: Codable {
    let name, city, country: String
    let position: Position
}

struct Position : Codable {
    let latitude, longitude: Double
}
