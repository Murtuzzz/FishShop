////
////  TabBarController.swift
////  FishShop
////
////  Created by Мурат Кудухов on 05.03.2024.
////
//
//enum Tabs: Int,CaseIterable {
//    case login
//    case products
//    case profile
//}
//
//struct User {
//    static var isAuthorized: Bool {
//        get {
//            return UserDefaults.standard.bool(forKey: "isAuthorized")
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "isAuthorized")
//        }
//    }
//}
//
//import UIKit
//
//class TabBarController: UITabBarController {
//    
//    private let productNavController = NavBarController(rootViewController: ProductsController())
//    private let searchNavController = NavBarController(rootViewController: ProfileController(login: "Dinglbob", id: ""))
//    private var profileController = NavBarController(rootViewController: LoginController())
//    
//    override func viewDidLoad() {
//        tabBar()
//        tabBarApperance()
//        //updateProfileTab()
//        switchTo(tab: .products)
//    }
//
//    func switchTo(tab: Tabs) {
//        selectedIndex = tab.rawValue
//    }
//    
//    func tabBar() {
//        viewControllers = [
//            generateVC(viewController: profileController, title: "Login", image: UIImage(systemName: "person.fill.questionmark.rtl")),
//            generateVC(viewController: productNavController, title: "Products", image: UIImage(systemName: "storefront")),
//            generateVC(viewController: searchNavController, title: "Profile", image: UIImage(systemName: "person"))
//        ]
//    }
//    
//    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
//        viewController.tabBarItem.title = title
//        viewController.tabBarItem.image = image
//        return viewController
//    }
//    
//    func updateProfileTab(login: String, id: String) {
//        if User.isAuthorized {
//            profileController.setViewControllers([ProfileController(login: login, id: id)], animated: false)
//            profileController.tabBarItem.title = "Profile"
//            profileController.tabBarItem.image = UIImage(systemName: "person")
//        } else {
//            profileController.setViewControllers([generateVC(viewController: LoginController(), title: "Login", image: UIImage(systemName: "person"))], animated: false)
//        }
//    }
//    
//    func logOut() {
//        profileController.setViewControllers([LoginController()], animated: false)
//        profileController.tabBarItem.title = "Login"
//        profileController.tabBarItem.image = UIImage(systemName: "person.fill.questionmark.rtl")
//    }
//
//    private func tabBarApperance() {
//        tabBar.tintColor = .white
//        tabBar.barTintColor = .gray
//        tabBar.backgroundColor = R.Colors.barBg
//        tabBar.backgroundImage = UIImage()
//        tabBar.shadowImage = UIImage()
//        tabBar.isTranslucent = true
//
//    }
//}
