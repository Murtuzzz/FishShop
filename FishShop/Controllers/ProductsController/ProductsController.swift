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
    
    let jsonString = """
[
    {"id":1,"name":"Grilled fish","description":"Бекещеке","price":"199.00","in_stock":true,"product_count":23.0,"category":1},
    {"id":2,"name":"Tasty salmon","description":"Бекещеке","price":"396.00","in_stock":true,"product_count":23.0,"category":1},
    {"id":3,"name":"Tasty frozen fish","description":"Бекещеке","price":"485.00","in_stock":true,"product_count":23.0,"category":2},
    {"id":4,"name":"Freeze fish","description":"Бекещеке","price":"390.00","in_stock":true,"product_count":23.0,"category":2},
    {"id":5,"name":"Gold fish","description":"Бекещеке","price":"396.00","in_stock":true,"product_count":23.0,"category":2}
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
        label.backgroundColor = .systemOrange.withAlphaComponent(0.7)
        return label
    }()
    
    private let profileView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.barBg.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
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
        if UserSettings.activeOrder != nil {
            if UserSettings.activeOrder == false {
                deliveryButton.alpha = 0
            } else {
                deliveryButton.alpha = 1
            }
        }
        print("Appear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateProductData), name: NSNotification.Name("basketUpdated"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProductController), name: NSNotification.Name("OrderPaid"), object: nil)
        
        
        view.backgroundColor = R.Colors.background
        UserSettings.basketInfo = []
        UserSettings.storeData = []
        UserSettings.orderInfo = []
        //UserSettings.ordersHistory = []
        UserSettings.orderPaid = false
        UserSettings.activeOrder = false
        if UserSettings.activeOrder == nil {
            UserSettings.activeOrder = false 
        }
        
        
        print("StoreData = \(UserSettings.storeData)")
        view.addSubview(buttons)
        view.addSubview(deliveryButton)
        view.addSubview(basketView)
        view.addSubview(basketButton)
        view.addSubview(profileView)
        view.addSubview(allBasketProdLabel)
        
        title = "Products"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        buttonActions()
        tableApperance()
        constraints()
        //getDataFromStore()
        //getDataFromStore()
        //        getUrl { prodList in
        //            print(prodList)
        //        }
        
    }
    
    func getUrl(completion: @escaping (String) -> Void) {
        
        let url = URL(string: "http://127.0.0.1:8000/catalog/products/?format=json")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            // Обработка ошибок
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                print("")
                // Добавим эту строку для распечатки полученных данных
                print("Received data: \(String(describing: String(data: data, encoding: .utf8)))")
                do {
                    // Попробуйте декодировать ответ в JSON
                    if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String] {
                        // Получите URL из JSON, если он существует
                        if let urlStr = json["url"] {
                            print("URL: \(urlStr)")
                            completion(urlStr)
                            // Здесь ваш код для использования urlStr в WebView
                        }
                    }
                } catch {
                    print("Invalid response data: \(error)")
                }
            }
        }
        task.resume()
    }
    
    private func buttonActions() {
        basketButton.addTarget(self, action: #selector(basketAction), for: .touchUpInside)
        deliveryButton.addTarget(self, action: #selector(deilveryButtonAction), for: .touchUpInside)
    }
    
    @objc func updateProductData() {
        // Обновите данные вашей пользовательской настройки здесь
        tableView.reloadData() // или обновление, специфичное для вашего UI
        print("Product Deleted From Basket")
    }
    
    @objc 
    func updateProductController() {
        // Обновите данные вашей пользовательской настройки здесь
        tableView.reloadData() // или обновление, специфичное для вашего UI
        allBasketProdCount = 0
        deliveryButton.alpha = 1
        print("Order paid")
    }
    
    @objc
    func basketAction() {
        let vc = BasketController()
        present(vc, animated: true)
        //navigationController?.pushViewController(vc, animated: true)
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            buttons.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -8),
            buttons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        //        cardsData = [.init(image: "Tasty salmon", price: 1990, title: "Tasty salmon", prodType: .salmon, prodId: 0),
        //                     .init(image: "Grilled fish", price: 2345, title: "Grilled fish", prodType: .salmon, prodId: 1),
        //                     .init(image: "Tasty frozen fish", price: 3843, title: "Tasty frozen fish", prodType: .frozen, prodId: 2),
        //                     .init(image: "Freeze fish", price: 1345, title: "Freeze fish", prodType: .frozen, prodId: 3),
        //                     .init(image: "Gold fish", price: 6799, title: "Gold fish", prodType: .salmon, prodId: 4)]
        //
        
        getDataFromStore()
        
        for _ in 0...cardsData.count-1 {
            basketInfoArray.append([])
            
        }
        
        tableView.reloadData()
        
    }
    
    
    
    func getDataFromStore() {
        if let products = parseProducts(from: jsonString) {
            for product in products {
                
                print("Product Name: \(product.name), Price: \(product.price), id \(product.id - 1), category \(product.category), in stock \(product.inStock), count \(Int(product.productCount))")
                
                if product.inStock == true {
                    
                    UserSettings.storeData.append([.init(title: product.name, price: product.price , quantity: Int(product.productCount), inStock: product.inStock, id: product.id, categoryId: product.category)])
                    //print(UserSettings.storeData)
                    
                    print(product.price)
                    cardsData.append(.init(image: product.name, price: Int(Double(product.price)!), title: product.name, prodType: .salmon, prodId: product.id-1, catId: product.category, productCount: Int(product.productCount), inStock: product.inStock))
                    //print(Double(product.price))
                }
            }
        }
        //print("StoreData = \(UserSettings.storeData)")
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
        print("didTapBasketButton tapped")
        print("\(self.basketInfoArray)")
        cardsData[indexPath.row].isInBasket.toggle()
        let cellData = displayDataSource[indexPath.row]
        self.cardsData[indexPath.row].prodCount += 1
        //self.cardsData[indexPath.row].prodCount += 1
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
        
        //print(UserSettings.basketInfo)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableCell.id, for: indexPath) as! ProductsTableCell
        
        let cellData = displayDataSource[indexPath.row]
        
        buttons.onFilterChange = { newFilter in
            //print("FILTER CHANGE")
            
            if newFilter == .all {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            } else if newFilter == .frozen {
                tableView.scrollToRow(at: IndexPath(row: 2, section: 0), at: .top, animated: true)
            } else {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
        
        cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title, title: cellData.title, prodId: cellData.prodId, prodCount: cellData.prodCount, isInBasket: cellData.isInBasket, wasInBasket: cellData.wasInBasket)
        cell.cellDelegate = self
        cell.basketDelegate = self
        cell.buttonClicked = { [self] in
            self.openVc(indexPath.row)
        }
        
        
        
        if UserSettings.basketInfo != nil {
            if UserSettings.basketInfo.isEmpty == false {
                if UserSettings.basketInfo[indexPath.row].isEmpty == false {
                    //print(UserSettings.basketInfo)
                    for el in UserSettings.basketInfo[indexPath.row] {
                        if el.inBasket == true {
                            print("\(el.title) was deleted from basket")
                            
                            //Кол-во товаров в корзине(индикатор)
                            if UserSettings.basketInfo.isEmpty {
                                UserSettings.basketProdQuant = 0
                            }
                            if UserSettings.basketProdQuant == 0 {
                                self.allBasketProdLabel.alpha = 0
                            } else {
                                self.allBasketProdLabel.text = "\(self.allBasketProdCount)"
                            }
                            
                            self.allBasketProdCount = UserSettings.basketProdQuant
                            
                            self.allBasketProdLabel.text = "\(self.allBasketProdCount)"
                            
                            print(self.allBasketProdCount)
                            
                            UserSettings.basketInfo[indexPath.row] = []
                            self.cardsData[indexPath.row].isInBasket = false
                            self.cardsData[indexPath.row].prodCount = 0
                            self.basketInfoArray[indexPath.row] = []
                            //UserSettings.basketInfo = self.basketInfoArray
                            
                            DispatchQueue.main.async {
                                cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                                title: cellData.title, prodId: cellData.prodId,
                                                prodCount: self.cardsData[indexPath.row].prodCount, isInBasket: cellData.isInBasket, wasInBasket: cellData.wasInBasket)
                                tableView.reloadRows(at: [indexPath], with: .none)
                            }
                            
                            self.basketInfoArray = UserSettings.basketInfo
                            
                            //print("deleted cell = \(UserSettings.basketInfo[indexPath.row])")
                            //print(UserSettings.basketInfo)
                        }
                    }
                }
            }
        }
        
        
        
        if UserSettings.orderPaid == true {
            //print(UserSettings.basketInfo)
            print("was deleted from basket \(UserSettings.basketInfo)")
            
            //Кол-во товаров в корзине(индикатор)
            UserSettings.basketProdQuant = 0
            self.allBasketProdCount = 0
            
            self.allBasketProdLabel.text = "\(self.allBasketProdCount)"
            
            print(self.allBasketProdCount)
            for i in 0...cardsData.count-1 {
                self.cardsData[i].isInBasket = false
                self.cardsData[i].prodCount = 0
            }
            
            //self.cardsData[indexPath.row].isInBasket = false
            //self.cardsData[indexPath.row].prodCount = 0
            
            DispatchQueue.main.async {
                cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                title: cellData.title, prodId: cellData.prodId,
                                prodCount: 0, isInBasket: false, wasInBasket: cellData.wasInBasket)
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
            //print("deleted cell = \(UserSettings.basketInfo[indexPath.row])")
            //print(UserSettings.basketInfo)
            UserSettings.orderPaid = false
        }
        
        cell.onPlusTap = {
            if self.cardsData[indexPath.row].prodCount > 0 {
                print("StoreData \(UserSettings.storeData)")
                self.allBasketProdCount += 1
                self.allBasketProdLabel.text = "\(self.allBasketProdCount)"
                self.cardsData[indexPath.row].prodCount += 1
                print("\(self.cardsData[indexPath.row].prodCount)")
                UserSettings.basketInfo[indexPath.row][0].quantity = self.cardsData[indexPath.row].prodCount
                DispatchQueue.main.async {
                    cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                    title: cellData.title, prodId: cellData.prodId,
                                    prodCount: self.cardsData[indexPath.row].prodCount, isInBasket: cellData.isInBasket, wasInBasket: cellData.wasInBasket)
                    tableView.reloadRows(at: [indexPath], with: .none)
                    //                print("\(self.cardsData[indexPath.row].prodCount) PLUS")
                    
                    self.basketInfoArray[indexPath.row][0].quantity = self.cardsData[indexPath.row].prodCount
                }
                
                UserSettings.basketProdQuant = self.allBasketProdCount
            }
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
                        cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                        title: cellData.title, prodId: cellData.prodId,
                                        prodCount: self.cardsData[indexPath.row].prodCount, isInBasket: cellData.isInBasket, wasInBasket: cellData.wasInBasket)
                        tableView.reloadRows(at: [indexPath], with: .none)
                        //                    print("\(self.cardsData[indexPath.row].prodCount) MINUS")
                    }
                    UserSettings.basketProdQuant = self.allBasketProdCount
                }
                
                
                //            print("UserSettig Basket MINUS TAPPED == \(UserSettings.basketInfo)")
                print(self.basketInfoArray)
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
        print("Количество \(cellData.prodCount), basket \(cellData.isInBasket)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = view.bounds.height
        return height/2.65
        
    }
    
    func infoButtonTapped(cell: UITableViewCell) {
        guard tableView.indexPath(for: cell) != nil else { return }
        
    }
    
    func parseProducts(from jsonString: String) -> [Product]? {
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        
        let decoder = JSONDecoder()
        do {
            let products = try decoder.decode([Product].self, from: jsonData)
            return products
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
}

