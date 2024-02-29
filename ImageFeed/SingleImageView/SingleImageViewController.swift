//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Anna on 19.01.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            singleImage.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
//
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var backButton: UIButton!
//    @IBOutlet weak var singleImage: UIImageView!
    
    //var image: UIImage!
    var scrollView: UIScrollView!
    var backButton: UIButton!
    var singleImage: UIImageView!
    var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        singleImage = UIImageView(image: image)
        singleImage.translatesAutoresizingMaskIntoConstraints = false
        singleImage.contentMode = .scaleAspectFit
        scrollView.addSubview(singleImage)
//        singleImage.image = image
        
        backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "Backward"), for: .normal)
        backButton.tintColor = UIColor.white
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
        view.addSubview(backButton)
        
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
            backButton.heightAnchor.constraint(equalToConstant: 24)
            ])
    }
    
//    @IBAction func backButtonDidTap(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
    
    @objc func backButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func shareButtonDidTap(_ sender: UIButton) {
            let share = UIActivityViewController(
                activityItems: [image],
                applicationActivities: nil
            )
        share.completionWithItemsHandler = { [weak self] activityType, completed, returnedItems, error in
            if completed {
                self?.dismiss(animated: true, completion: nil)
            }
        }
            present(share, animated: true, completion: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "YP Black")
        
        shareButton = UIButton(type: .custom)
        shareButton.setImage(UIImage(named: "ButtonSharing"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonDidTap(_:)), for: .touchUpInside)
        view.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -50),
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let horizontalScale = visibleRectSize.width / imageSize.width
        let vetricalScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(horizontalScale, vetricalScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImage
    }
}
