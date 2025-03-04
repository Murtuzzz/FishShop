//
//  ViewController.swift
//  FishShop
//
//  Created by Мурат Кудухов on 01.03.2024.
//

struct CardInfo {
    let image: String
    let price: Int
    let title: String
    let prodType: ProdType
    let prodId: Int
    let catId: Int
    let productCount: Int
    let inStock: Bool
    var prodCount: Int = 0
    var isInBasket = false
    var wasInBasket = false
}

import UIKit

class ProductsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView = UITableView()
    private var basketInfoArray: [[BasketInfo]] = []
    private var isJsonLoaded: Bool = false
    private var isProdDeletedNow: Bool = true
    //let basketController = BasketController()
    
    // Получаем текущую дату и время
    let currentTime: DateFormatter = {
        let date = DateFormatter()
        date.dateFormat = "HH:mm:ss"
        return date
    }()
    
    
    
    private var unavailableProducts = [[BasketInfo]]() {
        didSet {
        }
    }
    private var unavailableInd: [Int] = []
    private var basketInfo = [[BasketInfo]]()
    private var storeProducts: [[String:Any]] = [[:]]
    
    let jsonString = """
[
    {"id":1,"name":"Grilled fish","description":"Бекещеке","price":"199.00","in_stock":true,"product_count":23.0,"category":1},
    {"id":2,"name":"Tasty salmon","description":"Бекещеке","price":"396.00","in_stock":true,"product_count":23.0,"category":1},
    {"id":3,"name":"Tasty frozen fish","description":"Бекещеке","price":"485.00","in_stock":true,"product_count":23.0,"category":2},
    {"id":4,"name":"Freeze fish","description":"Бекещеке","price":"390.00","in_stock":true,"product_count":23.0,"category":2},
    {"id":5,"name":"Gold fish","description":"Бекещеке","price":"396.00","in_stock":true,"quantity":23.0,"category":2}
]
"""
    
    private let basketView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.barBg.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
    }()
    
    private var allBasketProdCount = 0
    private var allBasketProdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.alpha = 0
        label.text = "6"
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 15
        label.layer.borderColor = R.Colors.background.cgColor
        label.layer.borderWidth = 4
        label.backgroundColor = .systemBlue.withAlphaComponent(0.7)
        return label
    }()
    
    private let profileView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.barBg.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.barBg
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let emptyView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.barBg
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let basketButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "basket"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let deliveryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "truck.box.badge.clock"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 22
        button.backgroundColor = R.Colors.barBg.withAlphaComponent(0.5)
        button.alpha = 0
        return button
    }()
    
    private var cardsData:[CardInfo] = []
    private let buttons = FilterButtons()
    
    private var selectedFilter: ProdFilter = .all
    private var displayDataSource: [CardInfo] {
        switch selectedFilter {
        case .all:
            return cardsData
        case .frozen:
            return cardsData.filter { item in
                return item.prodType == .frozen
            }
        case .salmon:
            return cardsData.filter { item in
                return item.prodType == .salmon
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("-------------------------------ProductsController------------------------------------")
        if UserSettings.activeOrder != nil {
            if UserSettings.activeOrder == false {
                deliveryButton.alpha = 0
            } else {
                deliveryButton.alpha = 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateProductData), name: NSNotification.Name("basketUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deilveryButtonAction), name: NSNotification.Name("orderPaid"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProductController), name: NSNotification.Name("OrderPaid"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(prodDeletedFromBasketNow), name: NSNotification.Name("prodDeleted"), object: nil)
        
        view.backgroundColor = R.Colors.background
        UserSettings.deletedFromBasketNow = true
        UserSettings.basketInfo = []
        UserSettings.storeData = []
        UserSettings.orderInfo = []
        UserSettings.dataFromStore = []
        UserSettings.unavailableProducts = []
        UserSettings.isLocChanging = false
        //UserSettings.ordersHistory = []
        UserSettings.orderPaid = false
        UserSettings.activeOrder = false
        if UserSettings.activeOrder == nil {
            UserSettings.activeOrder = false
        }
        
        view.addSubview(buttons)
        view.addSubview(deliveryButton)
        view.addSubview(basketView)
        view.addSubview(basketButton)
        view.addSubview(profileView)
        //view.addSubview(emptyView)
        //view.addSubview(emptyView2)
        view.addSubview(allBasketProdLabel)
        
        title = "Products"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        buttonActions()
        
        setJsonProductsOnScreen {
            //self.tableView.reloadData()
            DispatchQueue.main.async {
                self.tableApperance()
            }
        }
        constraints()
        //getDataFromStore()
        //getDataFromStore()
    }
    //func getUrl(completion: @escaping ([[String: Any]]) -> Void) {
    private func buttonActions() {
        basketButton.addTarget(self, action: #selector(basketAction), for: .touchUpInside)
        deliveryButton.addTarget(self, action: #selector(deilveryButtonAction), for: .touchUpInside)
    }
    @objc func updateProductData() {
        // Обновите данные вашей пользовательской настройки здесь
        tableView.reloadData() // или обновление, специфичное для вашего UI
    }
    @objc func orderPaid() {
        // Обновите данные вашей пользовательской настройки здесь
        // или обновление, специфичное для вашего UI
    }
    
    @objc
    func updateProductController() {
        tableView.reloadData()
        allBasketProdCount = 0
        deliveryButton.alpha = 1
    }
    
    @objc
    func prodDeletedFromBasketNow() {
        self.isProdDeletedNow = true
    }
    
    @objc
    func basketAction() {
        if UserSettings.basketInfo != nil {
            basketInfo = UserSettings.basketInfo }
        checkAvailableProd(orders: basketInfo)
        let vc = BasketController()
        present(vc, animated: true)
        
    }
    
    func checkAvailableProd(orders: [[BasketInfo]]) {
        guard let url = URL(string: "http://192.168.31.48:5002/api/orders") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(orders)
            request.httpBody = jsonData
        } catch {
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return
            } else if let data = data {
                //guard let data = data else { return }
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let unavailableProducts = jsonResponse["unavailable_items"] as? [Int],
                       let isProductsAvailable = jsonResponse["success"] as? Bool {
                        
                        if isProductsAvailable {
                            //self.isProductsInStock = true
                        } else {
                            self.unavailableProducts = []
                            self.unavailableInd = unavailableProducts
                            
                            for i in 1...self.basketInfo.count {
                                for u in self.unavailableInd {
                                    if self.basketInfo[i-1].isEmpty == false {
                                        if self.basketInfo[i-1][0].id == u {
                                            self.unavailableProducts.append(self.basketInfo[i-1])
                                        } else {
                                        }
                                    }
                                }
                            }
                            
                            
                            DispatchQueue.main.async {
                                UserSettings.unavailableProducts = self.unavailableProducts
                                
                                
                                //self.prodToDel = self.unavailableProducts
                                //self.displayBasketAlert()
                                //self.unavailableProducts = []
                            }
                        }
                    } else {
                        //self.isProductsInStock = true
                    }
                    
                } catch {
                }
            }
        }
        task.resume()
    }
    
    @objc
    func deilveryButtonAction() {
        let vc = DeliveryViewController()
        //present(vc, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func tableApperance() {
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.backgroundColor = R.Colors.background
        self.tableView.estimatedRowHeight = 150
        self.tableView.allowsSelection = true
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.register(ProductsTableCell.self, forCellReuseIdentifier: ProductsTableCell.id)
        
        view.addSubview(tableView)
        
        buttons.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 144),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            
            buttons.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -8),
            buttons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        for _ in 0...cardsData.count-1 {
            basketInfoArray.append([])
        }
        tableView.reloadData()
    }
    
    
    
    func getDataFromStore() {
        if let products = parseProducts(from: jsonString) {
            for product in products {
                
                if product.inStock == true {
                    
                    UserSettings.storeData.append([.init(id: product.id, title: product.name, description: product.name, price: product.price , inStock: product.inStock, quantity: Int(product.productCount), categoryId: product.category)])
                    
                    cardsData.append(.init(image: product.name, price: Int(Double(product.price)!), title: product.name, prodType: .salmon, prodId: product.id-1, catId: product.category, productCount: Int(product.productCount), inStock: product.inStock))
             
                }
            }
        }
      
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            basketView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            basketView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -16),
            basketView.heightAnchor.constraint(equalToConstant: 56),
            basketView.widthAnchor.constraint(equalToConstant: 80),
            
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            profileView.heightAnchor.constraint(equalToConstant: 56),
            profileView.widthAnchor.constraint(equalToConstant: 160),
            
            basketButton.trailingAnchor.constraint(equalTo: basketView.trailingAnchor, constant: 8),
            basketButton.centerYAnchor.constraint(equalTo: basketView.centerYAnchor),
            basketButton.heightAnchor.constraint(equalToConstant: 80),
            basketButton.widthAnchor.constraint(equalTo: basketButton.heightAnchor),
            
            deliveryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deliveryButton.centerYAnchor.constraint(equalTo: basketButton.centerYAnchor),
            deliveryButton.heightAnchor.constraint(equalToConstant: 56),
            deliveryButton.widthAnchor.constraint(equalTo: deliveryButton.heightAnchor),
            
            allBasketProdLabel.leadingAnchor.constraint(equalTo: basketView.trailingAnchor, constant: -18),
            allBasketProdLabel.centerYAnchor.constraint(equalTo: basketView.centerYAnchor, constant: -24),
            allBasketProdLabel.heightAnchor.constraint(equalToConstant: 32),
            allBasketProdLabel.widthAnchor.constraint(equalTo: allBasketProdLabel.heightAnchor),
            
            //            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 144),
            //            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            //            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            //            emptyView.heightAnchor.constraint(equalToConstant: view.bounds.height/4),
            //
            //            emptyView2.topAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: 24),
            //            emptyView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            //            emptyView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            //            emptyView2.heightAnchor.constraint(equalToConstant: view.bounds.height/3.6),
        ])
    }
}

//MARK: - TableSettings

extension ProductsController: CellDelegate, BasketCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayDataSource.count
    }
    
    func didTapBasketButton(inCell cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let cellData = displayDataSource[indexPath.row]
        cardsData[indexPath.row].isInBasket.toggle()
        self.cardsData[indexPath.row].prodCount += 1
        if cellData.prodCount == 0 {
            allBasketProdCount += 1
            allBasketProdLabel.text = "\(allBasketProdCount)"
            allBasketProdLabel.alpha = 1
            UserSettings.basketProdQuant = allBasketProdCount
        }
        
        self.basketInfoArray[indexPath.row] = [
            .init(title: self.cardsData[indexPath.row].title,
                  price: Double(self.cardsData[indexPath.row].price),
                  quantity: self.cardsData[indexPath.row].prodCount,
                  id: self.cardsData[indexPath.row].prodId, inBasket: self.cardsData[indexPath.row].wasInBasket, catId: self.cardsData[indexPath.row].catId, inStock: self.cardsData[indexPath.row].inStock, prodCount: self.cardsData[indexPath.row].prodCount)]
        
        UserSettings.basketInfo = self.basketInfoArray
        
        tableView.reloadRows(at: [indexPath], with: .none)
        print("#ProductsController#cell.didTapBasketButton#BasketInfo = \(UserSettings.basketInfo ?? [])")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableCell.id, for: indexPath) as! ProductsTableCell
        
        let cellData = displayDataSource[indexPath.row]
        let descriptionController = CardInfoController(title: cellData.title, image: cellData.image)
        
        buttons.onFilterChange = { newFilter in
            
            if newFilter == .all {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            } else if newFilter == .frozen {
                tableView.scrollToRow(at: IndexPath(row: 2, section: 0), at: .top, animated: true)
            } else {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        if let productCount = self.storeProducts[indexPath.row]["quantity"] as? Int {
            if self.cardsData[indexPath.row].prodCount == productCount {
     
                cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title, title: cellData.title, prodId: cellData.prodId, prodCount: cellData.prodCount, isInBasket: cellData.isInBasket, wasInBasket: cellData.wasInBasket, inStock: false)
            } else {
            
                cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title, title: cellData.title, prodId: cellData.prodId, prodCount: cellData.prodCount, isInBasket: cellData.isInBasket, wasInBasket: cellData.wasInBasket, inStock: true)
            }
        }
        
        cell.cellDelegate = self
        cell.basketDelegate = self
        cell.buttonClicked = { [self] in
            navigationController?.pushViewController(descriptionController, animated: true)
        }
        
        descriptionController.descBasketTap = {
            let cellData = self.displayDataSource[indexPath.row]
            self.cardsData[indexPath.row].isInBasket.toggle()
            self.cardsData[indexPath.row].prodCount += 1
            if cellData.prodCount == 0 {
                self.allBasketProdCount += 1
                self.allBasketProdLabel.text = "\(self.allBasketProdCount)"
                self.allBasketProdLabel.alpha = 1
                UserSettings.basketProdQuant = self.allBasketProdCount
            }
            
            self.basketInfoArray[indexPath.row] = [
                .init(title: self.cardsData[indexPath.row].title,
                      price: Double(self.cardsData[indexPath.row].price),
                      quantity: self.cardsData[indexPath.row].productCount,
                      id: self.cardsData[indexPath.row].prodId, inBasket: self.cardsData[indexPath.row].wasInBasket, catId: self.cardsData[indexPath.row].catId, inStock: self.cardsData[indexPath.row].inStock, prodCount: self.cardsData[indexPath.row].prodCount)]
            
            UserSettings.basketInfo = self.basketInfoArray
            
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        descriptionController.descPlusTap = {
            if self.cardsData[indexPath.row].prodCount > 0 {
                self.allBasketProdCount += 1
                self.allBasketProdLabel.text = "\(self.allBasketProdCount)"
                self.cardsData[indexPath.row].prodCount += 1
                UserSettings.basketInfo[indexPath.row][0].quantity = self.cardsData[indexPath.row].prodCount
                DispatchQueue.main.async {
                    if let productCount = self.storeProducts[indexPath.row]["quantity"] as? Int {
                        if self.cardsData[indexPath.row].prodCount == productCount {
                         
                            cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                            title: cellData.title, prodId: cellData.prodId,
                                            prodCount: self.cardsData[indexPath.row].prodCount, isInBasket: cellData.isInBasket, wasInBasket: cellData.wasInBasket, inStock: false)
                            tableView.reloadRows(at: [indexPath], with: .none)
                            descriptionController.checkAvailability(inStock: false)
                        } else {
                         
                            cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                            title: cellData.title, prodId: cellData.prodId,
                                            prodCount: self.cardsData[indexPath.row].prodCount, isInBasket: cellData.isInBasket, wasInBasket: cellData.wasInBasket, inStock: true)
                            descriptionController.checkAvailability(inStock: true)
                            tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                    
                    self.basketInfoArray[indexPath.row][0].quantity = self.cardsData[indexPath.row].prodCount
                }
                //UserSettings.basketProdQuant = self.allBasketProdCount
            }
            print("#ProductsController#descriptionController.descPlusTap#BasketInfo = \(UserSettings.basketInfo ?? [])")
        }
        
        descriptionController.descMinusTap = {
            
            if self.cardsData[indexPath.row].prodCount > 0 {
                if self.cardsData[indexPath.row].prodCount > 0 {
                    self.cardsData[indexPath.row].prodCount -= 1
                    self.allBasketProdCount -= 1
                    self.allBasketProdLabel.text = "\(self.allBasketProdCount)"
                    if self.allBasketProdCount == 0 {
                        self.allBasketProdLabel.alpha = 0
                    }
                    //UserSettings.basketInfo[indexPath.row][0].quantity = self.cardsData[indexPath.row].prodCount //??
                    if self.cardsData[indexPath.row].prodCount == 0 {
                        self.cardsData[indexPath.row].isInBasket = false
                        //UserSettings.basketInfo[indexPath.row] = []
                        self.basketInfoArray[indexPath.row] = []
                    }
                    DispatchQueue.main.async {
                        if let productCount = self.storeProducts[indexPath.row]["quantity"] as? Int {
                            if self.cardsData[indexPath.row].prodCount == productCount {
                                cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                                title: cellData.title, prodId: cellData.prodId,
                                                prodCount: self.cardsData[indexPath.row].prodCount, isInBasket: cellData.isInBasket, wasInBasket: cellData.wasInBasket, inStock: false)
                                descriptionController.checkAvailability(inStock: false)
                                tableView.reloadRows(at: [indexPath], with: .none)
                            } else {
                                cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                                title: cellData.title, prodId: cellData.prodId,
                                                prodCount: self.cardsData[indexPath.row].prodCount, isInBasket: cellData.isInBasket, wasInBasket: cellData.wasInBasket, inStock: true)
                                descriptionController.checkAvailability(inStock: true)
                                tableView.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                        if self.basketInfoArray[indexPath.row].isEmpty == false {
                            self.basketInfoArray[indexPath.row][0].quantity = self.cardsData[indexPath.row].prodCount
                        }
                    }
                }
                
            }
            print("#ProductsController#descriptionController.descMinusTap#BasketInfo = \(UserSettings.basketInfo ?? [])")
        }
        
        if UserSettings.basketInfo != nil {
            if UserSettings.basketInfo.isEmpty == false {
                if UserSettings.basketInfo[indexPath.row].isEmpty == false {
                    for el in UserSettings.basketInfo[indexPath.row] {
                        if el.inBasket == true {
                            
                            //Кол-во товаров в корзине(индикатор)
                            if UserSettings.basketInfo.isEmpty {
                                UserSettings.basketProdQuant = 0
                            }
                            if UserSettings.basketProdQuant == 0 {
                                self.allBasketProdLabel.alpha = 0
                            } else {
                                self.allBasketProdLabel.text = "\(self.allBasketProdCount)"
                            }
                            
                            if UserSettings.basketInfo[indexPath.row][0].quantity == 0 {
                                UserSettings.basketInfo[indexPath.row] = []
                                // self.cardsData[indexPath.row].isInBasket = false
                                self.cardsData[indexPath.row].prodCount = 0
                                self.basketInfoArray[indexPath.row] = []
                            } else {
                                self.cardsData[indexPath.row].prodCount = UserSettings.basketInfo[indexPath.row][0].quantity
                                self.basketInfoArray[indexPath.row] = UserSettings.basketInfo[indexPath.row]
                                self.cardsData[indexPath.row].isInBasket = false
                                UserSettings.basketInfo[indexPath.row][0].inBasket = false
                            }
                            
                            self.allBasketProdCount = UserSettings.basketProdQuant
                            self.allBasketProdLabel.text = "\(self.allBasketProdCount)"
                            
                            DispatchQueue.main.async {
                                if let productCount = self.storeProducts[indexPath.row]["quantity"] as? Int {
                                    if self.cardsData[indexPath.row].prodCount == productCount {
                                        cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                                        title: cellData.title, prodId: cellData.prodId,
                                                        prodCount: self.cardsData[indexPath.row].prodCount, isInBasket: cellData.isInBasket, wasInBasket: cellData.wasInBasket, inStock: false)
                                        tableView.reloadRows(at: [indexPath], with: .none)
                                        //descriptionController.checkAvailability(inStock: false)
                                    } else {
                                        cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                                        title: cellData.title, prodId: cellData.prodId,
                                                        prodCount: self.cardsData[indexPath.row].prodCount, isInBasket: cellData.isInBasket, wasInBasket: cellData.wasInBasket, inStock: true)
                                        tableView.reloadRows(at: [indexPath], with: .none)
                                        //descriptionController.checkAvailability(inStock: true)
                                    }
                                }
                            }
                            self.basketInfoArray = UserSettings.basketInfo
                        } else {
                        }
                    }
                } else {
                    if UserSettings.deletedFromBasketNow {
                        
                        
                        var ind = 0
                        var sc = 0
                        
                        for i in 0...cardsData.count-1 {
                            sc = 0
                            ind = 0
                            for bel in UserSettings.basketInfo {
                                ind += 1
                                if bel.isEmpty == false {
                                    if cardsData[i].title == bel[0].title {
                                        sc += 1
                                    }
                                }
                                
                                if sc == 0 && ind == 5 {
                                    cardsData[i].prodCount = 0
                                    self.basketInfoArray[i] = []
                                    sc = 0
                                }
                            }
                            
                        }
                        
                        //self.basketInfoArray[indexPath.row] = []
                        self.allBasketProdCount = UserSettings.basketProdQuant
                        self.allBasketProdLabel.text = "\(self.allBasketProdCount)"
                        
                        if self.allBasketProdCount == 0 {
                            allBasketProdLabel.alpha = 0
                        }
                        
                        DispatchQueue.main.async {
                            cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                            title: cellData.title, prodId: cellData.prodId,
                                            prodCount: self.cardsData[indexPath.row].prodCount, isInBasket: cellData.isInBasket, wasInBasket: cellData.wasInBasket, inStock: false)
                        }
                        
                        UserSettings.deletedFromBasketNow = false
                    }
                }
            }
        }
        
        if UserSettings.orderPaid == true {
            
            //Кол-во товаров в корзине(индикатор)
            UserSettings.basketProdQuant = 0
            self.allBasketProdCount = 0
            
            self.allBasketProdLabel.text = "\(self.allBasketProdCount)"
            
            for i in 0...cardsData.count-1 {
                self.cardsData[i].isInBasket = false
                self.cardsData[i].prodCount = 0
            }
            
            //self.cardsData[indexPath.row].isInBasket = false
            //self.cardsData[indexPath.row].prodCount = 0
            
            DispatchQueue.main.async {
                cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                title: cellData.title, prodId: cellData.prodId,
                                prodCount: 0, isInBasket: false, wasInBasket: cellData.wasInBasket, inStock: true)
                //tableView.reloadRows(at: [indexPath], with: .none)
                //tableView.reloadData()
            }
            UserSettings.basketProdQuant = 0
            self.basketInfoArray = UserSettings.basketInfo
            
            if UserSettings.basketProdQuant == 0 {
                UserSettings.orderPaid = false
                for _ in 0...cardsData.count-1 {
                    basketInfoArray.append([])
                }
                tableView.reloadData()
            }
            self.allBasketProdLabel.alpha = 0
            UserSettings.orderPaid = false
        }
        
        
        cell.onPlusTap = {
            if self.cardsData[indexPath.row].prodCount > 0 {
                
                self.allBasketProdCount += 1
                self.allBasketProdLabel.text = "\(self.allBasketProdCount)"
                self.cardsData[indexPath.row].prodCount += 1
                UserSettings.basketInfo[indexPath.row][0].quantity = self.cardsData[indexPath.row].prodCount
                DispatchQueue.main.async {
                    if let productCount = self.storeProducts[indexPath.row]["quantity"] as? Int {
                        if self.cardsData[indexPath.row].prodCount == productCount {
                            cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                            title: cellData.title, prodId: cellData.prodId,
                                            prodCount: self.cardsData[indexPath.row].prodCount, isInBasket: cellData.isInBasket, wasInBasket: cellData.wasInBasket, inStock: false)
                            descriptionController.checkAvailability(inStock: false)
                            tableView.reloadRows(at: [indexPath], with: .none)
                        } else {
                            cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                            title: cellData.title, prodId: cellData.prodId,
                                            prodCount: self.cardsData[indexPath.row].prodCount, isInBasket: cellData.isInBasket, wasInBasket: cellData.wasInBasket, inStock: true)
                            descriptionController.checkAvailability(inStock: true)
                            tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                    self.basketInfoArray[indexPath.row][0].quantity = self.cardsData[indexPath.row].prodCount
                }
                UserSettings.basketProdQuant = self.allBasketProdCount
            }
            print("#ProductsController#cell.onPlusTap#BasketInfo = \(UserSettings.basketInfo ?? [])")
        }
        
        cell.onMinusTap = {
            if self.cardsData[indexPath.row].prodCount > 0 {
                if self.cardsData[indexPath.row].prodCount > 0 {
                    self.cardsData[indexPath.row].prodCount -= 1
                    self.allBasketProdCount -= 1
                    self.allBasketProdLabel.text = "\(self.allBasketProdCount)"
                    if self.allBasketProdCount == 0 {
                        self.allBasketProdLabel.alpha = 0
                    }
                    UserSettings.basketInfo[indexPath.row][0].quantity = self.cardsData[indexPath.row].prodCount
                    if self.cardsData[indexPath.row].prodCount == 0 {
                        self.cardsData[indexPath.row].isInBasket = false
                        UserSettings.basketInfo[indexPath.row] = []
                        self.basketInfoArray[indexPath.row] = []
                    }
                    DispatchQueue.main.async {
                        if let productCount = self.storeProducts[indexPath.row]["quantity"] as? Int {
                            if self.cardsData[indexPath.row].prodCount == productCount {
                                cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                                title: cellData.title, prodId: cellData.prodId,
                                                prodCount: self.cardsData[indexPath.row].prodCount, isInBasket: cellData.isInBasket, wasInBasket: cellData.wasInBasket, inStock: false)
                                tableView.reloadRows(at: [indexPath], with: .none)
                            } else {
                                cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                                title: cellData.title, prodId: cellData.prodId,
                                                prodCount: self.cardsData[indexPath.row].prodCount, isInBasket: cellData.isInBasket, wasInBasket: cellData.wasInBasket, inStock: true)
                                tableView.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                        if self.basketInfoArray[indexPath.row].isEmpty == false {
                            self.basketInfoArray[indexPath.row][0].quantity = self.cardsData[indexPath.row].prodCount
                        }
                    }
                    UserSettings.basketProdQuant = self.allBasketProdCount
                }
            }
            print("#ProductsController#cell.onMinusTap#BasketInfo = \(UserSettings.basketInfo ?? [])")
        }
        
        descriptionController.check = {
            if let productCount = self.storeProducts[indexPath.row]["quantity"] as? Int {
                if self.cardsData[indexPath.row].prodCount == productCount {
                    descriptionController.checkAvailability(inStock: false)
                } else {
                    descriptionController.checkAvailability(inStock: true)
                }
            }
        }
        return cell
    }
    
    func openVc(_ index: Int) {
        let cellData = displayDataSource[index]
        navigationController?.pushViewController(CardInfoController(title: cellData.title, image: cellData.image), animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = displayDataSource[indexPath.row]
        //let descriptionController = CardInfoController(title: cellData.title, image: cellData.image)
        //navigationController?.pushViewController(descriptionController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = view.bounds.height
        if view.bounds.height == 603 {
            height = view.bounds.height/2.35
        } else {
            height = view.bounds.height/2.65
            //return height/2.65
        }
        return height
    }
    
    func infoButtonTapped(cell: UITableViewCell) {
        guard tableView.indexPath(for: cell) != nil else { return }
    }
    
    func setJsonProductsOnScreen(completion: @escaping () -> Void) {
        self.getUrl { prodList in
            
            for product in prodList {
                
                // Убедитесь, что product имеет доступ к ожидаемым ключам
                if let name = product["name"] as? String,
                   let price = product["price"] as? String,
                   let description = product["description"] as? String,
                   let id = product["id"] as? Int,
                   let category = product["category"] as? Int,
                   let inStock = product["in_stock"] as? Bool,
                   let productCount = product["quantity"] as? Int {
                    
                    
                    if inStock == true {
                        UserSettings.storeData.append([.init(id: id, title: name, description: self.description, price: price, inStock: inStock, quantity: productCount, categoryId: category)])
                        
                        self.cardsData.append(.init(image: name, price: Int(Double(price)!), title: name, prodType: .salmon, prodId: id - 1, catId: Int(category), productCount: Int(productCount), inStock: inStock))
                        
                        
                    }
                }
                else {
                }
            }
            completion()
            
        }
    }
    //MARK: - Back: Get products from server bbb
    func getUrl(completion: @escaping ([[String: Any]]) -> Void) {
        //let url = URL(string: "http://127.0.0.1:5002/get-url")
        let url = URL(string: "http://192.168.31.48:5002/get-url")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
            } else if let data = data {
                do {
                    if let productArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] {
                        self.storeProducts = productArray
                        completion(productArray)
                        UserSettings.dataFromStore = productArray
                    }
                } catch {
                }
            }
        }
        task.resume()
    }
    
    func parseProducts(from jsonString: String) -> [Product]? {
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        
        let decoder = JSONDecoder()
        do {
            let products = try decoder.decode([Product].self, from: jsonData)
            return products
        } catch {
            return nil
        }
    }
    
}
