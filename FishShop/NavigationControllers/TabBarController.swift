//
//  TabBarController.swift
//  FishShop
//
//  Created by Мурат Кудухов on 05.03.2024.
//

enum Tabs: Int,CaseIterable {
    case profile
    case products
    case search
}

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        tabBar()
        tabBarApperance()
        switchTo(tab: .products)
        
    }
    func switchTo(tab: Tabs) {
        selectedIndex = tab.rawValue
    }
    
    func tabBar() {
        
        let productNavController = NavBarController(rootViewController: ProductsController())
        let searchNavController = NavBarController(rootViewController: SearchController())
        let profileController = NavBarController(rootViewController: ProfileController())
        
        viewControllers = [
            generateVC(viewController: profileController, title: "Profile", image: UIImage(systemName: "person")),
            generateVC(viewController: productNavController, title: "Products", image: UIImage(systemName: "storefront")),
            generateVC(viewController: searchNavController, title: "Search", image: UIImage(systemName: "magnifyingglass"))
        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
        
    }

    
    
    private func tabBarApperance() {
        tabBar.tintColor = .white
        tabBar.barTintColor = .gray
        tabBar.backgroundColor = R.Colors.barBg
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.isTranslucent = true
//
//
//        let positionOnX: CGFloat = 10
//        let positionOnY: CGFloat = 14
//
//        let width = tabBar.bounds.width - positionOnX * 2
//        let height = tabBar.bounds.height + positionOnY * 2
//
//        let roundLayer = CAShapeLayer()
//
//        let bezierPath = UIBezierPath(
//            roundedRect: CGRect(
//                x: positionOnX,
//                y: tabBar.bounds.minY - positionOnY,
//                width: width, height: height),
//            cornerRadius: height/2)
//
//        roundLayer.path = bezierPath.cgPath
//
//        tabBar.layer.insertSublayer(roundLayer, at: 0)
//        tabBar.itemWidth = width / 4
//        tabBar.itemPositioning = .centered
    }
}

