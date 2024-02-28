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
    
//    @IBOutlet private weak var imageCell: UIImageView!
//    @IBOutlet private weak var dateLabel: UILabel!
//    @IBOutlet private weak var likeButton: UIButton!
//    @IBOutlet private weak var gradientView: GradientLayer!
    
    // MARK: - UI Components
    private let imageCell: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let gradientView: GradientLayer = {
        let gradientView = GradientLayer()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        return gradientView
    }()
    
    
    // MARK: - Public Properties
    
    static let reuseIdentifier = "ImageListCell"
    
    // MARK: - Private Properties
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - IB Actions
    
//    @IBAction func tappedLikeButton(_ sender: Any) {
//
//    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        contentView.addSubview(imageCell)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(gradientView)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor, constant: -10),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            likeButton.topAnchor.constraint(equalTo: imageCell.topAnchor),
            likeButton.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor)
        ])
        
        dateLabel.font = UIFont(name: "YS Display-Medium", size: 13)
        dateLabel.textColor = .white
        
        likeButton.addTarget(self, action: #selector(tappedLikeButton(_:)), for: .touchUpInside)
        likeButton.setTitle("", for: .normal)
    }
    
    
    // MARK: - Public Methods
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        likeButton.setTitle("", for: .normal)
//    }
    
    func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientView.startColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0)
        gradientView.endColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    func configCell(with imageName: String, with index: Int) {
        guard let image = UIImage(named: imageName) else { return }
        
        imageCell.image = image
        imageCell.contentMode = .scaleAspectFit
        imageCell.clipsToBounds = true
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = dateFormatter.string(from: Date())
        
        let isLiked = index % 2 == 0
        let likeImage = isLiked ? UIImage(named: "Like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    @objc private func tappedLikeButton(_ sender: UIButton) {
        
    }
}
