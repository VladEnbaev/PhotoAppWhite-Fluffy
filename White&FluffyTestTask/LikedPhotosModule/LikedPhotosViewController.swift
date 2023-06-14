//
//  LikedPhotosViewController.swift
//  White&FluffyTestTask
//
//  Created by Влад Енбаев on 14.06.2023.
//

import UIKit

class LikedPhotosViewController: UIViewController {

    let tableView = UITableView()
    
    var photos : [UnsplashPhoto]?
    
    var dataManager : DataManagerProtocol? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        loadPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadPhotos()
    }
    
    func loadPhotos() {
        guard let dataManager = dataManager else { return }
        self.photos = dataManager.fetchPhotos().map { $0.createModel() }
        
        tableView.reloadData()
    }
}

extension LikedPhotosViewController: BaseViewProtocol {
    func setupViews() {
        view.backgroundColor = .white
        
        setupTableView()
        setupNavigationBar()
        
        constraintViews()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LikedPhotosCell.self, forCellReuseIdentifier: LikedPhotosCell.identifier)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Liked Photos"
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh,
                                            target: self,
                                            action: #selector(refreshButtonTapped))
        let deleteAllButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                              target: self,
                                              action: #selector(deleteButtonTapped))
        
        navigationItem.rightBarButtonItems = [deleteAllButton, refreshButton]
    }
    
    @objc func refreshButtonTapped() {
        loadPhotos()
    }
    
    @objc func deleteButtonTapped() {
        dataManager?.deleteAllPhotos()
        loadPhotos()
    }
    
    func constraintViews() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension LikedPhotosViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LikedPhotosCell.identifier) as? LikedPhotosCell
                    else { return UITableViewCell() }
        guard let photo = photos?[indexPath.row],
              let url = URL(string: photo.urls.regular) else { return UITableViewCell() }
        
        
        cell.configure(with: url, text: photo.user.username)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension LikedPhotosViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let photo = photos?[indexPath.row],
              let dataManager = dataManager else { return }
        
        let detailPhotoVC = DetailPhotoViewController()
        detailPhotoVC.configure(with: photo, dataManager: dataManager)
        
        navigationController?.pushViewController(detailPhotoVC, animated: true)
    }
}
