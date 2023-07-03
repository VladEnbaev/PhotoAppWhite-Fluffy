//
//  UnsplashPhotoEntity.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 14.06.2023.
//

import Foundation
import CoreData

class UnsplashPhotoEntity : NSManagedObject {
    
    func createModel() -> UnsplashPhoto {
        let position = UnsplashPhoto.Position(latitude: 0,
                                              longitude: 0)
        
        let location = UnsplashPhoto.Location(name: self.locationName,
                                              position: position)
        let user = UnsplashUser(id: nil,
                                username: self.username ?? "",
                                name: nil)
        let urls = UnsplashPhoto.Urls(raw: nil,
                                      full: nil,
                                      thumb: nil,
                                      small: nil,
                                      regular: self.url ?? "")
        
        let photo = UnsplashPhoto(id: self.id ?? "",
                                  createdAt: self.createdAt,
                                  width: 0,
                                  height: 0,
                                  downloads: Int(self.downloads),
                                  likedByUser: self.likedByUser,
                                  description: self.textDescription,
                                  location: location,
                                  urls: urls,
                                  user: user)
        
        return photo
    }
}
