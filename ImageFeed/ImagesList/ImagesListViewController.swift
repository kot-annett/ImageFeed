//
//  ViewController.swift
//  ImageFeed
//
//  Created by Anna on 08.01.2024.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    private let tableView = UITableView()
    
    var photos: [Photo] = []
    private var imagesListServices = ImagesListService()
    
    // MARK: - UIStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        configureNotificationObserver()
    }
    
    // MARK: - Private methods
    
    private func configureNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableViewAnimated),
            name: ImagesListService.didChangeNotification,
            object: nil
        )}
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "YP Black")
        navigationController?.navigationBar.barTintColor = UIColor(named: "YP Black")
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListServices.photos.count
        photos = imagesListServices.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in //todo
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }

        let photo = photos[indexPath.row]
        imageListCell.selectionStyle = .none
        imageListCell.configCell(for: photo)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        imageListCell.addGradient()
        imageListCell.backgroundColor = UIColor.clear

        return imageListCell
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            imagesListServices.fetchPhotosNextPage() 
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let singleImageVC = SingleImageViewController()
        singleImageVC.modalPresentationStyle = .fullScreen
        singleImageVC.modalTransitionStyle = .coverVertical
        
        let photo = photos[indexPath.row]
        singleImageVC.imageURL = URL(string: photo.largeImageURL)
        present(singleImageVC, animated: true, completion: nil)
    }
}
