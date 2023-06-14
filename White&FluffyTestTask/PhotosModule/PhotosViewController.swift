//
//  ViewController.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 13.06.2023.
//

import UIKit

class PhotosViewController: UIViewController{
    
    var networkService : NetworkServiceProtocol? = nil
    
    var collectionView : UICollectionView!
    
    var photos: [UnsplashPhoto]? = nil
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        constraintViews()
    }
    
}

extension PhotosViewController: BaseViewProtocol {
    func setupViews() {
        setupPhotosCollectionView()
        setupSearchBar()
        setupPhotosCollectionView()
    }
    
    func setupPhotosCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseId)
        
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupNavigationBar() {
//        let titleLabel = UILabel()
//        titleLabel.text = "PHOTOS"
//        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
//        titleLabel.textColor = #colorLiteral(red: 0.5019607843, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
//        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
//
//        navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Photos"
    }
    
    private func setupSearchBar() {
        let seacrhController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = seacrhController
        seacrhController.hidesNavigationBarDuringPresentation = false
        seacrhController.obscuresBackgroundDuringPresentation = false
        seacrhController.searchBar.delegate = self
    }
    
    func constraintViews() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    
    }
    
}
extension PhotosViewController {
    private func getImages(for query: String) {
        networkService?.getImages(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photos):
                    self.photos = photos
                    print(photos[1])
                    print(photos.count)
                    self.collectionView.reloadData()
                case .failure(let error):
                    self.showAlert(error: error)
                }
            }
        }
    }
    
    private func getRandomImages(count: Int) {
        networkService?.getRandomImages(count: count) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photos):
                    self.photos = photos
                    print(photos[1])
                    print(photos.count)
                    self.collectionView.reloadData()
                case .failure(let error):
                    self.showAlert(error: error)
                }
            }
        }
    }
    
    func showAlert(error: Error) {
        let alert = UIAlertController(title: "ops",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "ok", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

extension PhotosViewController : UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        getRandomImages(count: 10)
    }
    
}

extension PhotosViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseId, for: indexPath) as! PhotosCell
        let unspashPhoto = photos?[indexPath.item]
        return cell
    }
}

extension PhotosViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        guard let image = cell.photoImageView.image else { return }
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos?[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}
