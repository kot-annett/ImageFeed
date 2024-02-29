//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Anna on 08.01.2024.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    
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
    
    // MARK: - Private Methods
    
    private func setupUI() {
        contentView.addSubview(imageCell)
        contentView.addSubview(gradientView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
        
        imageCell.layer.cornerRadius = 16
        imageCell.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            dateLabel.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor, constant: -10),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            likeButton.topAnchor.constraint(equalTo: imageCell.topAnchor),
            //likeButton.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
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
    
    @objc private func tappedLikeButton(_ sender: UIButton) {
        
    }
    
    // MARK: - Public Methods
    
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
        
        let isImageLiked = index % 2 == 0
        setLikeButton(isLiked: isImageLiked)
    }
    
    func setLikeButton(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "Like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
}
