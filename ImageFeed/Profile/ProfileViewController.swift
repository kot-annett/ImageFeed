//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Anna on 18.01.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    private let userPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 23.0)
        return label
    }()
    
    private let loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello world!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private let logOutButton: UIButton = {
        let button = UIButton(type: .system)
        if let exitImageButton = UIImage(named: "exitButton") {
            button.setImage(exitImageButton, for: .normal)
        }
        button.tintColor = UIColor(named: "YP Red")
        return button
    }()
    
    // MARK: - Properties
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver : NSObjectProtocol?
    
    // MARK: - UIStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        addSubviews()
        configurateConstraints()
        updateProfileDetails()
    }
    
    // MARK: - IB Actions
    
    @objc func logOutButtonTapped() {
    //TODO: - настроить кнопку выхода
    }
    
    // MARK: - Public Methods
    
    private func addSubviews() {
        [
            userPhoto,
            userNameLabel,
            loginNameLabel,
            descriptionLabel,
            logOutButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func configurateConstraints() {
        userPhoto.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userPhoto.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userPhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        userPhoto.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true

        userNameLabel.leadingAnchor.constraint(equalTo: userPhoto.leadingAnchor).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: userPhoto.bottomAnchor, constant: 8).isActive = true
 
        loginNameLabel.leadingAnchor.constraint(equalTo: userPhoto.leadingAnchor).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true

        descriptionLabel.leadingAnchor.constraint(equalTo: userPhoto.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true

        logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        logOutButton.centerYAnchor.constraint(equalTo: userPhoto.centerYAnchor).isActive = true
    }
    
    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        
        let cache = ImageCache.default
        cache.clearDiskCache()
        let processor = RoundCornerImageProcessor(cornerRadius: 42)
        userPhoto.kf.setImage(with: url,
                              placeholder: UIImage(named: "placeholder"),
                              options: [.processor(processor), .transition(.fade(1))],
                              progressBlock: nil) { result in
            switch result {
            case .success(let value):
                print("Изображение успешно загружено: \(value.image)")
            case .failure(let error):
                print("Ошибка при загрузке изображения: \(error)")
            }
        }
    }
    
    func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        
        userNameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
}
