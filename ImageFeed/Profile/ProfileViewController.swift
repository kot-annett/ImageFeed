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
    
    private var userPhoto: UIImageView!
    private var userNameLabel: UILabel!
    private var loginNameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var logOutButton: UIButton!
    
    // MARK: - Properties
    
    let profileService = ProfileService.shared
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
    
    @IBAction private func logOutButtonTapped() {
    }
    
    // MARK: - Public Methods
    
    private func addSubviews() {
        let profileImage = UIImage(named: "placeholder")
        userPhoto = UIImageView(image: profileImage)
        userPhoto.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userPhoto)
        
        userNameLabel = UILabel()
        userNameLabel.text = "Екатерина Новикова"
        userNameLabel.textColor = .white
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        
        loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = .gray
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.text = "Hello world!"
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        logOutButton = UIButton.systemButton(
            with: UIImage(named: "exitButton")!,
            target: self,
            action: #selector(Self.logOutButtonTapped)
        )
        logOutButton.tintColor = UIColor(named: "YP Red")
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOutButton)
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
        userPhoto?.kf.setImage(with: url,
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
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        
        userNameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
}
