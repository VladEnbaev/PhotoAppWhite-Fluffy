//
//  AppBuilder.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 14.06.2023.
//

import Foundation
import UIKit

class AppBuilder {
    
    func createTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        let photoVC = createPhotosFlow()
        let likedPhotosVC = createLikedPhotosFlow()
        
        tabBar.viewControllers = [photoVC, likedPhotosVC]
        tabBar.selectedViewController = photoVC
        
        return tabBar
    }
    
    private func createPhotosFlow() -> UIViewController{
        let networkService = NetworkService()
        let photosVC = PhotosViewController()
        photosVC.networkService = networkService
        
        let navigationController = UINavigationController(rootViewController: photosVC)
        
        navigationController.tabBarItem.title = "Photos"
        navigationController.tabBarItem.image = R.Icons.tabBarPhotos
        
        return navigationController
    }
    
    private func createLikedPhotosFlow() -> UIViewController {
        let mocVC = UIViewController()
        mocVC.view.backgroundColor = .blue
        
        let navigationController = UINavigationController(rootViewController: mocVC)
        
        navigationController.tabBarItem.title = "Favorites"
        navigationController.tabBarItem.image = R.Icons.tabBarFavorites
        
        return navigationController
    }
}
