//
//  File.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 18.06.2023.
//

import Foundation


protocol PhotoCellViewModelProtocol {
    var imageURL: URL { get set }
    
    init(photo: UnsplashPhoto)
}

class PhotoCellViewModel : PhotoCellViewModelProtocol{
    
    var imageURL: URL
    
    required init(photo: UnsplashPhoto) {
        self.imageURL = URL(string: photo.urls.small ?? "")!
    }
}
