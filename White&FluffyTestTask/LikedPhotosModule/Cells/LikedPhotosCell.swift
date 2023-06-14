//
//  LikedPhotosTableViewCell.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 14.06.2023.
//

import UIKit
import SDWebImage


class LikedPhotosCell: UITableViewCell {
   
    static let identifier = "LikedPhotosCellID"
    
    var photoImageView = UIImageView()
    var usernameLabel = UILabel()
    let indicator = UIActivityIndicatorView(style: .medium)

    func configure(with url: URL, text: String) {
        indicator.startAnimating()
        self.photoImageView.sd_setImage(with: url) {_,_,_,_ in
            DispatchQueue.main.async{
                self.indicator.stopAnimating()
            }
        }
        
        usernameLabel.text = text
        setupViews()
    }
    
    
}

extension LikedPhotosCell : BaseViewProtocol {
    func setupViews() {
        
        setupPhotoImageView()
        setupIndicator()
        setupUsernameLabel()
        
        constraintViews()
    }
    
    func setupPhotoImageView() {
        photoImageView.layer.cornerRadius = 2
        photoImageView.clipsToBounds = true
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.backgroundColor = .white
        photoImageView.contentMode = .scaleAspectFill
    }
    
    func setupIndicator() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
    }
    
    func setupUsernameLabel() {
        usernameLabel.font = UIFont.systemFont(ofSize: 20,
                                               weight: .bold)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constraintViews() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            photoImageView.heightAnchor.constraint(equalToConstant: 70),
            photoImageView.widthAnchor.constraint(equalToConstant: 70),
            
            indicator.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 5),
            indicator.widthAnchor.constraint(equalToConstant: 5),
            
            usernameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 30),
            usernameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            usernameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
