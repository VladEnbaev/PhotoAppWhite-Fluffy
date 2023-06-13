//
//  ViewController.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 13.06.2023.
//

import UIKit

class PhotosViewController: UIViewController{
    
    let photosCollectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        constraintViews()
    }
    
}

extension PhotosViewController: BaseViewProtocol {
    func setupViews() {
        setupPhotosCollectionView()
    }
    
    func setupPhotosCollectionView() {
        
    }
    
    func constraintViews() {
        <#code#>
    }
    
}
