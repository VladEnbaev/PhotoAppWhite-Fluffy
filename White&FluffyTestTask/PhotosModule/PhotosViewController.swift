//
//  ViewController.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 13.06.2023.
//

import UIKit
import SDWebImage

class PhotosViewController: UIViewController{
    
    var collectionView : UICollectionView!
    var statusLabel = UILabel()
    let refreshControl = UIRefreshControl()
    
    var viewModel: PhotosViewModelProtocol!
    
    private let itemsPerRow: CGFloat = 2
    private let inset : CGFloat = 8
    private let sectionInserts = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        constraintViews()
        
        bindViewModel()
        getRandomImages()
    }
}
//MARK: - Actions
extension PhotosViewController {
    private func showAlert(errorText: String) {
        let alert = UIAlertController(title: "ops",
                                      message: errorText,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "ok", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    private func showStatusLabel(_ bool: Bool){
        statusLabel.isHidden = !bool
        collectionView.isHidden = bool
    }
    
    @objc func refreshButtonTapped() {
        getRandomImages()
    }
}

//MARK: - ViewModelMethods
extension PhotosViewController {
    func bindViewModel() {
        viewModel.isLoading.bind() { [weak self] isLoading in
            guard let isLoading = isLoading else { return }
            self?.showStatusLabel(isLoading)
        }
        
        viewModel.errorText?.bind() { [weak self] recivedText in
            guard let text = recivedText else { return }
            self?.showAlert(errorText: text)
        }
    }
    
    private func getImages(for query: String) {
        viewModel.getImages(for: query) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func getRandomImages() {
        viewModel.getRandomImages { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
}

//MARK: - Setup Views
extension PhotosViewController: BaseViewProtocol {
    func setupViews() {
        view.backgroundColor = .white
        
        setupPhotosCollectionView()
        setupSearchBar()
        setupPhotosCollectionView()
        setupNavigationBar()
        setupStatusLabel()
    }
    
    private func setupPhotosCollectionView() {
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
        
        let refreshButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshButtonTapped)
        )
        
        navigationItem.rightBarButtonItem = refreshButton
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        collectionView.addSubview(refreshControl)
    }
    
    private func setupSearchBar() {
        let seacrhController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = seacrhController
        seacrhController.hidesNavigationBarDuringPresentation = false
        seacrhController.obscuresBackgroundDuringPresentation = false
        seacrhController.searchBar.delegate = self
    }
    
    private func setupStatusLabel() {
        statusLabel.text = "Wait a second..."
        statusLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        statusLabel.textAlignment = .center
        statusLabel.textColor = .black
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constraintViews() {
        view.addSubview(collectionView)
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            statusLabel.heightAnchor.constraint(equalToConstant: 200),
            statusLabel.widthAnchor.constraint(equalToConstant: 400)
        ])
    
    }
}

//MARK: - UISearchBarDelegate
extension PhotosViewController : UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        getImages(for: query)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getRandomImages()
    }
    
}

//MARK: - UICollectionViewDataSource
extension PhotosViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseId, for: indexPath) as! PhotosCell
        cell.setup(with: viewModel.getURLForRow(at: indexPath))
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension PhotosViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let detailVC = DetailPhotoViewController()
        detailVC.viewModel = viewModel.viewModelForSelectedRow(at: indexPath)

        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotosCell else { return }
        UIView.animate(withDuration: 0.2) {
            cell.contentView.alpha = 0.4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotosCell else { return }
        UIView.animate(withDuration: 0.2) {
            cell.contentView.alpha = 1
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
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
