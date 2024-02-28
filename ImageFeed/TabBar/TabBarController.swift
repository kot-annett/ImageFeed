//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Anna on 27.02.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
            
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil
        )
        
        imagesListViewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewControllers?.append(imagesListViewController)
        //view.addSubview(imagesListViewController)
            
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        profileViewController.view.translatesAutoresizingMaskIntoConstraints = false
        //view.addSubview(profileViewController)
           
       self.viewControllers = [imagesListViewController, profileViewController]
       }
}
