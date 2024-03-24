//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Anna on 19.01.2024.
//

import UIKit
import ProgressHUD

final class SingleImageViewController: UIViewController {
    
    var imageURL: URL?
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            singleImage.image = image
            if let unwrappedImage = image {
                rescaleAndCenterImageInScrollView(image: unwrappedImage)
            }
        }
    }

    private let singleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        return scrollView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Backward"), for: .normal)
        button.tintColor = UIColor.white
        button.setTitle("", for: .normal)
        button.addTarget(
            self,
            action: #selector(backButtonDidTap(_:)),
            for: .touchUpInside
        )
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ButtonSharing"), for: .normal)
        button.addTarget(
            self,
            action: #selector(shareButtonDidTap), for: .touchUpInside
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupScrollView()
        setSingleImage()
    }
 
    @objc func backButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func shareButtonDidTap(_ sender: UIButton) {
            let share = UIActivityViewController(
                activityItems: [singleImage.image ?? UIImage()],
                applicationActivities: nil
            )
        share.popoverPresentationController?.sourceView = self.view
        self.present(share, animated: true, completion: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "YP Black")
        [scrollView,
         shareButton,
         backButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        scrollView.addSubview(singleImage)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            singleImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            singleImage.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            singleImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            singleImage.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -50),
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setSingleImage() {
        UIBlockingProgressHUD.show()
        singleImage.kf.setImage(with: imageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.singleImage.contentMode = .scaleAspectFill
                //self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    func setupScrollView() {
        scrollView.delegate = self
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так. Попробовать ещё раз?",
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Не надо", style: .cancel))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            self.setSingleImage()
        }))
        present(alert, animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let imageSize = image.size
        singleImage.frame.size = imageSize
        scrollView.contentSize = imageSize
        let minZoomScale = min(scrollView.bounds.size.width / imageSize.width, scrollView.bounds.size.height / imageSize.height)
        
        scrollView.minimumZoomScale = minZoomScale
        scrollView.maximumZoomScale = 4.0
        
        scrollView.zoomScale = minZoomScale
        
        let xOffset = max(0, (scrollView.contentSize.width - scrollView.bounds.size.width) / 2)
        let yOffset = max(0, (scrollView.contentSize.height - scrollView.bounds.size.height) / 2)
        scrollView.contentOffset = CGPoint(x: xOffset, y: yOffset)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImage
    }
}

