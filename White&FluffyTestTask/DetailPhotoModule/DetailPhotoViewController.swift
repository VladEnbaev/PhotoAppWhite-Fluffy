//
//  ViewController.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 14.06.2023.
//

import UIKit
import SDWebImage

class DetailPhotoViewController: UIViewController {
    
    var viewModel : DetailPhotoViewModelProtocol!
    
    private let likeButton = UIButton()
    private let photoImageView = UIImageView()
    
    private var usernameButton = UIButton()
    private var geoButton = UIButton()
    private var downloadsButton = UIButton()
    private let dateLabel = UILabel()
    
    let indicator = UIActivityIndicatorView(style: .large)
    
    private let imageViewSizeMultiplier : CGFloat = 0.4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewModelDidChange = { [weak self] viewModel in
            self?.setStatusForFavoriteButton()
        }
        setupViews()
        constraintViews()
    }
}

//MARK: - Actions
extension DetailPhotoViewController {
    
    @objc func likeButtonTapped() {
        viewModel.likeButtonTapped()
    }
    
    private func showAlert(error: String) {
        let alert = UIAlertController(title: "ops",
                                      message: error,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "ok", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    private func setStatusForFavoriteButton() {
        if viewModel.isLiked {
            likeButton.setImage(R.Icons.likeFilled,
                                for: .normal)
        } else {
            likeButton.setImage(R.Icons.like,
                                for: .normal)
        }
    }
}

//MARK: - Setup Views
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
        setStatusForFavoriteButton()
        
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
        
        indicator.startAnimating()
        self.photoImageView.sd_setImage(with: viewModel.imageURL) {_,_,_,_ in
            DispatchQueue.main.async{
                self.indicator.stopAnimating()
            }
        }
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupInfoButtons() {
        createInfoButton(button: usernameButton,
                         image: R.Icons.person,
                         text: viewModel.usersName)
        
        createInfoButton(button: downloadsButton,
                         image: R.Icons.downloads,
                         text: viewModel.downloads)
        
        createInfoButton(button: geoButton,
                         image: R.Icons.geo,
                         text: viewModel.geolocation)
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
        dateLabel.text = viewModel.createdAt
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

