//
//  Resources.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 14.06.2023.
//

import Foundation
import UIKit

typealias R = Resources

struct Resources {
    enum IDs {
        static let unsplashAuthID = "BN1-jX1MuvL8gagcdvR7vEaGTbJx9TSRbUsUzV4ltRU"
    }
    enum Icons {
        static let like = UIImage(systemName: "heart")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)) ?? UIImage()
        static let likeFilled = UIImage(systemName: "heart.fill") ?? UIImage()
        static let person = UIImage(systemName: "person") ?? UIImage()
        static let downloads = UIImage(systemName: "arrow.down.circle") ?? UIImage()
        static let geo = UIImage(systemName: "location.circle") ?? UIImage()
        static let tabBarPhotos = UIImage(systemName: "photo.stack") ?? UIImage()
        static let tabBarFavorites = UIImage(systemName: "heart") ?? UIImage()
    }
}
