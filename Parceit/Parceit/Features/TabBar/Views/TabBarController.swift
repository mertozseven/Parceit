//
//  TabBarController.swift
//  Parceit
//
//  Created by Mert Ozseven on 13.12.2024.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    // MARK: - Navigation
    private func setupTabs() {
        let searchVC = createNav(
            with: "Search",
            and: UIImage(systemName: "mail.and.text.magnifyingglass.rtl"),
            vc: SearchViewController()
        )
        let createVC = createNav(
            with: "Create",
            and: UIImage(systemName: "qrcode"),
            vc: CreateViewController()
        )
        let profileVC = createNav(
            with: "Profile",
            and: UIImage(systemName: "person.fill"),
            vc: ProfileViewController()
        )
        self.setViewControllers([searchVC, createVC, profileVC], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        vc.title = title
        nav.navigationBar.prefersLargeTitles = true
        vc.navigationItem.largeTitleDisplayMode = .always
        
        return nav
    }

}
