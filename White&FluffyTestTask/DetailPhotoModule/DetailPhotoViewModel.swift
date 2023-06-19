//
//  DetailPhotoViewModel.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 18.06.2023.
//

import Foundation

protocol DetailPhotoViewModelProtocol {
    var dataManager: DataManagerProtocol { get set }
    var usersName: String { get }
    var downloads: String { get }
    var geolocation: String { get }
    var createdAt: String { get }
    var imageURL: URL? { get }
    var isLiked: Bool { get }
    
    var viewModelDidChange: ((DetailPhotoViewModelProtocol) -> Void)? { get set }

    init(photo: UnsplashPhoto, dataManager: DataManagerProtocol)
    
    func likeButtonTapped()
}


class DetailPhotoViewModel: DetailPhotoViewModelProtocol{
    var dataManager: DataManagerProtocol
    
    var usersName: String {
        photo.user.name ?? ""
    }
    var downloads: String {
        photo.downloads == nil ? "-" : "\(photo.downloads!)"
    }
    var geolocation: String {
        photo.location?.name ?? "-"
    }
    var createdAt: String {
        photo.dateOfCreation?.formatted() ?? "-"
    }
    
    var isLiked: Bool {
        get {
            photo.likedByUser
        }
        set {
            photo.likedByUser = newValue
            viewModelDidChange?(self)
        }
        
    }
    
    var imageURL: URL? {
        guard let url = URL(string: photo.urls.regular) else { return nil }
        return url
    }
    
    private var photo: UnsplashPhoto
    
    var viewModelDidChange: ((DetailPhotoViewModelProtocol) -> Void)?
    
    required init(photo: UnsplashPhoto, dataManager: DataManagerProtocol) {
        self.photo = photo
        self.dataManager = dataManager
    }
    
    func likeButtonTapped() {
        isLiked.toggle()
        
        if isLiked {
            dataManager.createPhoto(from: photo)
        } else {
            dataManager.deletePhoto(with: photo.id)
        }
    }
}
