//
//  PhotosViewModel.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 18.06.2023.
//

import Foundation

protocol PhotosViewModelProtocol {
    var isLoading: Observable<Bool> { get set }
    var errorText: Observable<String>? { get set }
    init(networkService: NetworkServiceProtocol, dataManager: DataManagerProtocol)
    func getImages(for query: String,completion: @escaping () -> Void)
    func getRandomImages(completion: @escaping () -> Void)
    func numberOfRows() -> Int
    func getURLForRow(at indexPath: IndexPath) -> URL?
}

class PhotosViewModel: PhotosViewModelProtocol {
    var photos: [UnsplashPhoto] = []
    private let networkService: NetworkServiceProtocol!
    private let dataManager: DataManagerProtocol!
    
    var isLoading = Observable(false)
    var errorText: Observable<String>?
    
    required init(networkService: NetworkServiceProtocol, dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
        self.networkService = networkService
    }
    
}

extension PhotosViewModel {
    
    func getImages(for query: String, completion: @escaping () -> Void) {
        self.isLoading.value = true
        networkService?.getImages(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photosResult):
                    self.photos = photosResult.results
                case .failure(let error):
                    self.errorText?.value = error.localizedDescription
                    break
                }
                self.isLoading.value = false
                completion()
            }
        }
    }
    
    func getRandomImages(completion: @escaping () -> Void) {
        self.isLoading.value = true
        networkService?.getRandomImages(count: 30) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photos):
                    self.photos = photos
                case .failure(let error):
                    self.errorText?.value = error.localizedDescription
                }
                self.isLoading.value = false
                completion()
            }
        }
    }
    
    func numberOfRows() -> Int {
        photos.count
    }
    
    func getURLForRow(at indexPath: IndexPath) -> URL? {
        let url = URL(string: photos[indexPath.row].urls.thumb ?? "")
        return url
    }
}
