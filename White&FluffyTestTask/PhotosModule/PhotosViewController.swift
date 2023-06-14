//
//  ViewController.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 13.06.2023.
//

import UIKit
import SDWebImage

class PhotosViewController: UIViewController{
    
    var networkService : NetworkServiceProtocol? = nil
    
    var collectionView : UICollectionView!
    
    var photos: [UnsplashPhoto]? = nil
    
    private let itemsPerRow: CGFloat = 2
    private let inset : CGFloat = 8
    private let sectionInserts = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        constraintViews()
        
        getRandomImages(count: 30)
    }
    
}

extension PhotosViewController: BaseViewProtocol {
    func setupViews() {
        setupPhotosCollectionView()
        setupSearchBar()
        setupPhotosCollectionView()
        setupNavigationBar()
    }
    
    func setupPhotosCollectionView() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseId)
        
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupNavigationBar() {
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
                case .success(let photosResult):
                    self.photos = photosResult.results
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
        getImages(for: query)
    }
    
}

extension PhotosViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseId, for: indexPath) as! PhotosCell
        guard let unspashPhotoUrlString = photos?[indexPath.item].urls.regular,
                let url = URL(string: unspashPhotoUrlString) else { return UICollectionViewCell() }
       
        cell.setup(with: url)
        return cell
    }
}

extension PhotosViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photo = photos?[indexPath.row] else { return }
        let detailVC = DetailPhotoViewController()
        let dataManager = CoreDataManager()
        detailVC.configure(with: photo, dataManager: dataManager)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotosCell else { return }
        UIView.animate(withDuration: 0.2) {
            cell.contentView.alpha = 0.4
        }
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = inset * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem : CGFloat = availableWidth / itemsPerRow - 1
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
}
