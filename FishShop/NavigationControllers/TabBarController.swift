import UIKit

enum Tabs: Int, CaseIterable {
    case login
    case products
    case profile
}

struct User {
    static var isAuthorized: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isAuthorized")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isAuthorized")
        }
    }
}


class CustomTabBar: UITabBar {
    
    private var shapeLayer: CALayer?
    private var selectionCircle: CAShapeLayer?
    
    override func draw(_ rect: CGRect) {
        addShape(at: selectedItemIndex())
    }
    
    private func addShape(at index: Int) {
        if let oldShapeLayer = self.shapeLayer {
            oldShapeLayer.removeFromSuperlayer()
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath(for: index)
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = R.Colors.barBg.cgColor
        shapeLayer.lineWidth = 0
        layer.insertSublayer(shapeLayer, at: 0)
        self.shapeLayer = shapeLayer
        
        addSelectionCircle(at: index)
    }
    
    private func addSelectionCircle(at index: Int) {
        let buttonWidth = self.frame.width / CGFloat(Tabs.allCases.count)
        let xOffset = buttonWidth * CGFloat(index) + buttonWidth / 2
        let yOffset = 0 // Немного выше таббара
        let radius: CGFloat = 25
        
        if let oldCircle = self.selectionCircle {
            oldCircle.removeFromSuperlayer()
        }
        
        let circlePath = UIBezierPath(ovalIn: CGRect(
            x: xOffset - radius,
            y: CGFloat(yOffset),
            width: radius * 2,
            height: radius * 2
        ))
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.systemBlue.cgColor
        circleLayer.opacity = 0.5
        
        // Добавляем анимацию появления круга
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 0.5
        animation.duration = 0.3
        circleLayer.add(animation, forKey: nil)
        layer.insertSublayer(circleLayer, above: shapeLayer)
        self.selectionCircle = circleLayer
        
    }
    
    private func createPath(for index: Int) -> CGPath {
        let buttonWidth = self.frame.width / CGFloat(Tabs.allCases.count)
        let xOffset = buttonWidth * CGFloat(index)
        let tabBarHeight: CGFloat = self.frame.height
        let cutoutRadius: CGFloat = 35
        let curveOffset: CGFloat = 45
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: xOffset + buttonWidth / 2 - cutoutRadius - curveOffset, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: xOffset + buttonWidth / 2 - cutoutRadius, y: curveOffset),
            controlPoint: CGPoint(x: xOffset + buttonWidth / 2 - cutoutRadius - curveOffset / 2, y: 0)
        )
        path.addCurve(
            to: CGPoint(x: xOffset + buttonWidth / 2 + cutoutRadius, y: curveOffset),
            controlPoint1: CGPoint(x: xOffset + buttonWidth / 2 - cutoutRadius / 2, y: cutoutRadius * 2),
            controlPoint2: CGPoint(x: xOffset + buttonWidth / 2 + cutoutRadius / 2, y: cutoutRadius * 2)
        )
        path.addQuadCurve(
            to: CGPoint(x: xOffset + buttonWidth / 2 + cutoutRadius + curveOffset, y: 0),
            controlPoint: CGPoint(x: xOffset + buttonWidth / 2 + cutoutRadius + curveOffset / 2, y: 0)
        )
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: tabBarHeight))
        path.addLine(to: CGPoint(x: 0, y: tabBarHeight))
        path.close()
        
        return path.cgPath
    }
    
    private func selectedItemIndex() -> Int {
        
        return (self.items ?? []).firstIndex { $0 == self.selectedItem } ?? 0
    }
    
    override var selectedItem: UITabBarItem? {
        didSet {
            shapeLayer?.removeFromSuperlayer()
            selectionCircle?.removeFromSuperlayer()
            addShape(at: selectedItemIndex())
        }
    }
}

class TabBarController: UITabBarController {
    
    private let productNavController = NavBarController(rootViewController: ProductsController())
    private let searchNavController = NavBarController(rootViewController: ProfileController(login: "Dinglbob", id: ""))
    private var profileController = NavBarController(rootViewController: LoginController())
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        guard let tabBarItems = tabBar.items else { return }
//        // Проверяем, какая вкладка выбрана на старте
//        if let selectedItem = tabBar.selectedItem,
//           let selectedIndex = tabBarItems.firstIndex(of: selectedItem) {
//            
//            // Проходимся по всем вкладкам и применяем трансформацию
//            for (index, tabBarItemView) in tabBar.subviews.enumerated() {
//                guard tabBarItemView is UIControl else { continue }
//                
//                let isSelected = index == selectedIndex
//                tabBarItemView.transform = isSelected
//                    ? CGAffineTransform(translationX: 0, y: -10).scaledBy(x: 0.8, y: 0.8)
//                    : .identity
//            }
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let tabBarItems = tabBar.items else { return }
        // Проверяем, какая вкладка выбрана на старте
        if let selectedItem = tabBar.selectedItem,
           let selectedIndex = tabBarItems.firstIndex(of: selectedItem) {
            
            // Проходимся по всем subviews и применяем стартовую трансформацию с анимацией
            for (index, tabBarItemView) in tabBar.subviews.enumerated() {
                guard tabBarItemView is UIControl else { continue }
                
                let isSelected = index == selectedIndex
                
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                    tabBarItemView.transform = isSelected
                        ? CGAffineTransform(translationX: 0, y: 0).scaledBy(x: 0.8, y: 0.8)
                        : .identity
                }, completion: nil)
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        tabBarAppearance()
        switchTo(tab: .products)
        
    }
    
    func switchTo(tab: Tabs) {
        selectedIndex = tab.rawValue
        
    }
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        
//        guard let tabBarItems = tabBar.items else { return }
//        // Проходимся по всем subviews таббара
//        for (index, tabBarItemView) in tabBar.subviews.enumerated() {
//            
//            guard tabBarItemView is UIControl else { continue }
//            
//            let isSelected = tabBarItems[index] == item
//            
//            // Если элемент выбран, применяем трансформацию, иначе сбрасываем трансформацию
//            tabBarItemView.transform = isSelected ? CGAffineTransform(scaleX: 0.8, y: 0.8) : .identity
//            
//        }
//    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let tabBarItems = tabBar.items else { return }
        
        // Проходимся по всем subviews таббара
        for (index, tabBarItemView) in tabBar.subviews.enumerated() {
            guard tabBarItemView is UIControl else { continue }
            
            let isSelected = tabBarItems[index] == item
            
            // Применяем трансформацию с анимацией
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                tabBarItemView.transform = isSelected
                    ? CGAffineTransform(translationX: 0, y: 0).scaledBy(x: 0.8, y: 0.8)
                    : .identity
            }, completion: nil)
        }
    }
    
    private func setupTabBar() {
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
        viewControllers = [
            generateVC(viewController: profileController,
                       title: "Login",
                       image: UIImage(systemName: "person.fill.questionmark.rtl")),
            generateVC(viewController: productNavController,
                       title: "Products",
                       image: UIImage(systemName: "storefront")),
            generateVC(viewController: searchNavController,
                       title: "Profile",
                       image: UIImage(systemName: "person"))
        ]
        
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        
        return viewController
    }
    
    func updateProfileTab(login: String, id: String) {
        if User.isAuthorized {
            profileController.setViewControllers([ProfileController(login: login, id: id)], animated: false)
            profileController.tabBarItem.title = "Profile"
            profileController.tabBarItem.image = UIImage(systemName: "person")
        } else {
            profileController.setViewControllers([generateVC(viewController: LoginController(),
                                                             title: "Login",
                                                             image: UIImage(systemName: "person"))], animated: false)
        }
    }
    
    func logOut() {
        profileController.setViewControllers([LoginController()], animated: false)
        profileController.tabBarItem.title = "Login"
        profileController.tabBarItem.image = UIImage(systemName: "person.fill.questionmark.rtl")
    }
    
    private func tabBarAppearance() {
        tabBar.tintColor = .white
        tabBar.backgroundColor = .clear//R.Colors.barBg
        tabBar.isTranslucent = false
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.unselectedItemTintColor = .systemGray
        
        //tabBar.selectedItem?.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .selected)
        
        
        if let items = tabBar.items {
                for item in items {
                    // Устанавливаем пустую строку для заголовка у активного состояния
                    item.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .selected)
                    
                    // Оставляем текст только для неактивного состояния (например, черный цвет)
                    item.setTitleTextAttributes([.foregroundColor: UIColor.systemGray], for: .normal)
                }
            }
        
    }
}
