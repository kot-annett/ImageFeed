//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Anna on 08.01.2024.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    static let reuseIdentifier = "ImageListCell"
    
    @IBAction func tappedLikeButton(_ sender: Any) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeButton.setTitle("", for: .normal)
    }
    
    func addGradient() {
        
    }
}
