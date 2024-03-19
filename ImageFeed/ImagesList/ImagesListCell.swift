//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Anna on 08.01.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    var imageLoadTask: DownloadTask?
    
    // MARK: - UI Components
    let imageCell: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    private let gradientView: GradientLayer = {
        let gradientView = GradientLayer()
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
        [
            imageCell,
            gradientView,
            dateLabel,
            likeButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        contentView.backgroundColor = UIColor(named: "YP Black")

        imageCell.layer.cornerRadius = 16
        imageCell.layer.masksToBounds = true
        imageCell.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            dateLabel.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor, constant: -8),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            likeButton.topAnchor.constraint(equalTo: imageCell.topAnchor, constant: 4),
            likeButton.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor)
        ])
        
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        dateLabel.textColor = .white
        
        likeButton.addTarget(self, action: #selector(tappedLikeButton(_:)), for: .touchUpInside)
        likeButton.setTitle("", for: .normal)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        imageCell.image = nil
    }
    
    @objc private func tappedLikeButton(_ sender: UIButton) {
        // TODO: - Добавить логику нажатия на лайк
    }
    
    // MARK: - Public Methods
    
    func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientView.startColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0)
        gradientView.endColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    func configCell(for photo: Photo) {
        imageCell.image = nil
        
        if let url = URL(string: photo.thumbImageURL) {
            imageCell.kf.indicatorType = .activity
            imageCell.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder_image"),
                options: []) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self.imageCell.kf.indicator?.stopAnimatingView()
                            self.imageCell.kf.indicatorType = .none
                        }
                    case .failure(let error):
                        print("Failed to load image: \(error)")
                    }
                }
        }
        
        if let createdAt = photo.createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            dateLabel.text = dateFormatter.string(from: createdAt)
        } else {
            dateLabel.text = "Дата неизвестна"
        }
    }
    
    func setLikeButton(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
}
