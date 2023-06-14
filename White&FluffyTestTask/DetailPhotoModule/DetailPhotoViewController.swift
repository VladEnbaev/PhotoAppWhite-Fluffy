//
//  ViewController.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 14.06.2023.
//

import UIKit
import SDWebImage

class DetailPhotoViewController: UIViewController {
    
    var dataManager: DataManagerProtocol? = nil
    
    private var photo : UnsplashPhoto? = nil
    
    let indicator = UIActivityIndicatorView(style: .large)
    
    private let likeButton = UIButton()
    private let photoImageView = UIImageView()
    
    private var usernameButton = UIButton()
    private var geoButton = UIButton()
    private var downloadsButton = UIButton()
    
    private let dateLabel = UILabel()
    
    private let imageViewSizeMultiplier : CGFloat = 0.4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constraintViews()
    }
    
    func configure(with photo: UnsplashPhoto, dataManager: DataManagerProtocol) {
        loadViewIfNeeded()
        self.dataManager = dataManager
        self.photo = photo
        
        setupViews()
    }
}

//actions
extension DetailPhotoViewController {
    
    @objc func likeButtonTapped() {
        photo?.likedByUser.toggle()
        checkLikeStatus()
    }
    
    func checkLikeStatus() {
        guard let photo = photo else { return }
        if photo.likedByUser {
            dataManager?.createPhoto(from: photo)
            likeButton.setImage(R.Icons.likeFilled,
                                for: .normal)
        } else {
            dataManager?.deletePhoto(with: photo.id)
            likeButton.setImage(R.Icons.like,
                                for: .normal)
        }
    }
    
    func showAlert(error: String) {
        let alert = UIAlertController(title: "ops",
                                      message: error,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "ok", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
}

extension DetailPhotoViewController: BaseViewProtocol {
    func setupViews() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        
        setupPhotoImageView()
        
        setupIndicator()
        setupDateLabel()
        
        setupLikeButton()
        setupInfoButtons()
    }
    
    private func setupIndicator() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
    }
    
    private func setupLikeButton() {
        if photo?.likedByUser ?? false {
            likeButton.setImage(R.Icons.likeFilled,
                                for: .normal)
        } else {
            likeButton.setImage(R.Icons.like,
                                for: .normal)
        }
        
        likeButton.tintColor = .systemRed
        
        likeButton.contentVerticalAlignment = .fill
        likeButton.contentHorizontalAlignment = .fill
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .allEvents)
    }
    
    private func setupPhotoImageView() {
        photoImageView.layer.cornerRadius = 20
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = .lightGray
        photoImageView.contentMode = .scaleAspectFill
        
        guard let url = URL(string: photo?.urls.regular ?? "") else { return }
        indicator.startAnimating()
        self.photoImageView.sd_setImage(with: url) {_,_,_,_ in
            DispatchQueue.main.async{
                self.indicator.stopAnimating()
            }
        }
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupInfoButtons() {
        createInfoButton(button: usernameButton,
                         image: R.Icons.person,
                         text: photo?.user.username ?? "-")
        
        createInfoButton(button: downloadsButton,
                         image: R.Icons.downloads,
                         text: "\(photo?.downloads ?? 0)")
        
        createInfoButton(button: geoButton,
                         image: R.Icons.geo,
                         text: photo?.location?.name ?? "-")
    }
    
    private func createInfoButton(button: UIButton, image: UIImage, text: String?){
        button.setTitle("  \(text ?? "")", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.tintColor = .black
        
        button.setImage(image, for: .normal)
        
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.widthAnchor.constraint(equalToConstant: 190).isActive = true
    }
    
    private func setupDateLabel() {
        dateLabel.text = photo?.createdAt ?? "00-00-0000"
        dateLabel.textColor = .systemGray
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constraintViews() {
        
        let infoStackView = UIStackView(arrangedSubviews: [usernameButton, geoButton, downloadsButton])
        infoStackView.axis = .vertical
        infoStackView.spacing = 15
        infoStackView.distribution = .equalSpacing
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(photoImageView)
        view.addSubview(dateLabel)
        view.addSubview(indicator)
        view.addSubview(infoStackView)
        view.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: imageViewSizeMultiplier),
            photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor),
            
        
            indicator.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            indicator.topAnchor.constraint(equalTo: photoImageView.topAnchor, constant: 140),
            indicator.heightAnchor.constraint(equalToConstant: 20),
            indicator.widthAnchor.constraint(equalToConstant: 20),
            
            dateLabel.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 20),
            
            downloadsButton.widthAnchor.constraint(equalToConstant: 190),
            geoButton.widthAnchor.constraint(equalToConstant: 190),
            usernameButton.widthAnchor.constraint(equalToConstant: 190),
            
            
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            infoStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 60),
            
            likeButton.centerYAnchor.constraint(equalTo: infoStackView.centerYAnchor),
            likeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            likeButton.heightAnchor.constraint(equalToConstant: 50),
            likeButton.widthAnchor.constraint(equalToConstant: 55),
            
            
        ])
    }
}

