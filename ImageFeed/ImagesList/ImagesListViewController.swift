//
//  ViewController.swift
//  ImageFeed
//
//  Created by Anna on 08.01.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let ShowSingleImageSequeIdentifier = "ShowSingleImage"
    
    // MARK: - UIStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ImagesListViewController: viewDidLoad() called")
        tableView.dataSource = self
        tableView.delegate = self
        tableView?.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ImagesListViewController: viewWillAppear(_:) called")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ImagesListViewController: viewDidAppear(_:) called")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ImagesListViewController: viewWillDisappear(_:) called")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("ImagesListViewController: viewDidDisappear(_:) called")
    }
    // MARK: - Public methods

    override func prepare(for seque: UIStoryboardSegue, sender: Any?) {
        if seque.identifier == ShowSingleImageSequeIdentifier {
            let viewController = seque.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: seque, sender: sender)
        }
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
        imageListCell.configCell(with: imageName, with: indexPath.row)
        imageListCell.addGradient()

        return imageListCell
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSequeIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageName = photosName[indexPath.row]
        
        guard let image = UIImage(named: imageName) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
}
