//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Anna on 18.01.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet private weak var userPhoto: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var loginNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var logOutButton: UIButton!
    
    // MARK: - UIStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - IB Actions
    
    @IBAction private func logOutButtonTapped(_ sender: UIButton) {
    }
    
    // MARK: - Public Methods
    
}
