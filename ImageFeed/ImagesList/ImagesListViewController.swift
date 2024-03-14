//
//  ViewController.swift
//  ImageFeed
//
//  Created by Anna on 08.01.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    // MARK: - UIStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        view.backgroundColor = UIColor(named: "YP Black")
        navigationController?.navigationBar.barTintColor = UIColor(named: "YP Black")
    }
    
    // MARK: - Private methods
    
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
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }

        let imageName = photosName[indexPath.row]
        imageListCell.selectionStyle = .none
        imageListCell.configCell(with: imageName, with: indexPath.row)
        imageListCell.addGradient()
        imageListCell.backgroundColor = UIColor.clear

        return imageListCell
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let singleImageVC = SingleImageViewController()
        singleImageVC.modalPresentationStyle = .fullScreen
        singleImageVC.modalTransitionStyle = .coverVertical
        
        let imageName = photosName[indexPath.row]
        singleImageVC.image = UIImage(named: imageName)
        present(singleImageVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageName = photosName[indexPath.row]
        
        guard let image = UIImage(named: imageName) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale //+ imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
}
