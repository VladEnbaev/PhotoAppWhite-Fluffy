//
//  PhotosCell.swift
//  PhotosLibrary
//
//  Created by Алексей Пархоменко on 18/08/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit
//import SDWebImage


class PhotosCell: UICollectionViewCell {
    
    
    static let reuseId = "PhotosCell"
    let indicator = UIActivityIndicatorView(style: .medium)
    
    var photoImageView = UIImageView()
    
    func setup(with imageURL: URL) {
        
        indicator.startAnimating()
        self.photoImageView.sd_setImage(with: imageURL) {_,_,_,_ in
            DispatchQueue.main.async{
                self.indicator.stopAnimating()
            }
        }
        
        setupViews()
        constraintViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
}

//MARK: - Setup Views
extension PhotosCell: BaseViewProtocol {
    
    func setupViews() {
        contentView.layer.cornerCurve = .circular
        setupPhotoImageView()
        setupIndicator()
    }
    
    private func setupPhotoImageView() {
        photoImageView.layer.cornerRadius = 10
        photoImageView.clipsToBounds = true
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.backgroundColor = .white
        photoImageView.contentMode = .scaleAspectFill
    }
    
    private func setupIndicator() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
    }
    
    func constraintViews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(indicator)
        
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            indicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 20),
            indicator.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
    
}
