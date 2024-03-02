//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Anna on 27.02.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarAppearance()
    }
    
    private func generateTabBar() {
        viewControllers = [
        generateVC(
            viewController: ImagesListViewController(),
            title: "",
            image: UIImage(named: "tab_editorial_no_active"),
            selectedImage: UIImage(named: "tab_editorial_active")
        ),
        generateVC(
            viewController: ProfileViewController(),
            title: "",
            image: UIImage(named: "tab_profile_no_active"),
            selectedImage: UIImage(named: "tab_profile_active")
        )]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?, selectedImage: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
        return viewController
    }
    
    private func setTabBarAppearance() {
        tabBar.tintColor = UIColor(named: "YP Black")
    }
}


