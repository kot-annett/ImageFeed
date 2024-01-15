//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Anna on 08.01.2024.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet private weak var imageCell: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var gradientView: UIView!
    
    // MARK: - Public Properties
    
    static let reuseIdentifier = "ImageListCell"
    
    // MARK: - Private Properties
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
   // MARK: - IB Actions
    
    @IBAction func tappedLikeButton(_ sender: Any) {
        
    }
    
    // MARK: - Public Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeButton.setTitle("", for: .normal)
    }
    
    func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).cgColor,
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1).cgColor
        ]
        gradientLayer.frame = gradientView.bounds
        gradientLayer.bounds.size.height = 30
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    func configCell(with imageName: String, with index: Int) {
        guard let image = UIImage(named: imageName) else {
            return
        }
        
        imageCell.image = image
        dateLabel.text = dateFormatter.string(from: Date())
        
        let isLiked = index % 2 == 0
        let likeImage = isLiked ? UIImage(named: "Like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
}
