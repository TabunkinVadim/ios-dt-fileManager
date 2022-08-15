//
//  MainTabBarController.swift
//  file-manager
//
//  Created by Табункин Вадим on 08.08.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupTabBar()
    }
    
    func setupTabBar() {
        let manager = createNavController(viewController: ManagerViewController(), itemName: "Documents", itemImage: "folder")
        let settings = createNavController(viewController: SettingsViewController(), itemName: "Settings", itemImage: "gearshape")
        viewControllers = [manager, settings]
    }
    
    func createNavController(viewController:UIViewController, itemName: String, itemImage: String) -> UINavigationController {
        let item = UITabBarItem(title: itemName, image: UIImage(systemName: itemImage)?.withAlignmentRectInsets(.init(top: 10, left: 0, bottom: 0, right: 0)), tag: 0 )
        item.titlePositionAdjustment = .init(horizontal: 0, vertical: 10 )
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = item
        return navController
    }
}
