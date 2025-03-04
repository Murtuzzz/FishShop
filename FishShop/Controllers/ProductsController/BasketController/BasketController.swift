//
//  Basket.swift
//  FishShop
//
//  Created by Мурат Кудухов on 05.04.2024.
//

import UIKit
import MapKit

struct Basket {
    let title: String
    var quantity: Int
    let price: Int
    let id: Int
    let time: String
}

class BasketController: UIViewController, UITableViewDelegate, UITableViewDataSource,AddressPickerDelegate {
    
    var basketProdData: [Basket] = []
    var isProductsInStock = false
    var unavailableInd: [Int] = []
    var unavailableProducts = [[BasketInfo]]()
    var prodToDel = [[BasketInfo]]()
    private var storeProducts: [[String:Any]] = [[:]]
    
    private var tableView = UITableView()
    private var basketProdCount = 0
    private var totalBasketPrice = 0.0
    private var userBasket = [[String]]()
    private var prices = [[Int]]()
    var onDeleteTap:((String) -> Void)?
    private var basketInfo = [[BasketInfo]]()
    var adress = ""
    var pricesView = PricesView(totalSum: 0.0)
    
    private let basketView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.barBg.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let locationTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        //textField.placeholder = "Введите адрес доставки"
        textField.textColor = .white
        textField.tintColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "Введите адрес доставки", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        //textField.text = ""
        return textField
    }()
    
    private let basketImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = R.Colors.barBg.withAlphaComponent(0.5)
        view.image = UIImage(systemName:"basket")
        return view
    }()
    
    private let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        //        button.setTitle("г. Владикавказ, ул. \(UserSettings.adress[0][0].adress)", for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .systemBlue
        return button
    }()
    
    private let locationImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //        view.tintColor = R.Colors.barBg.withAlphaComponent(0.5)
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named:"location")
        return view
    }()
    
    private let saveLocationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBlue.withAlphaComponent(0.5)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        return button
    }()
    
    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.setTitle("Оплатить", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        return button
    }()
    
    private let totalLabelSum: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = R.Fonts.avenirBook(with: 32)
        return label
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .white
        label.font = R.Fonts.avenirBook(with: 32)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Корзина"
        //label.font = R.Fonts.avenirBook(with: 36)
        label.font = UIFont.boldSystemFont(ofSize: 36)
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        print("-------------------------------BasketController------------------------------------")
        //     locationButton.setTitle("г. Владикавказ, ул. \(UserSettings.adress[0][0].adress)", for: .normal)
        self.storeProducts = UserSettings.dataFromStore ?? []
        if UserSettings.unavailableProducts.isEmpty {
            isProductsInStock = true
        } else {
            isProductsInStock = false
        }
        
        print("#BasketController#viewWillAppear#")
        print("BasketInfo = \(UserSettings.basketInfo ?? [])")
        print("StoreData = \(UserSettings.dataFromStore ?? [])")
    }
    
    // --MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = R.Colors.background
        view.addSubview(basketView)
        view.addSubview(saveLocationButton)
        view.addSubview(locationTextField)
        view.addSubview(payButton)
        //view.addSubview(locationButton)
        view.addSubview(locationImage)
        //view.addSubview(totalLabelSum)
        view.addSubview(titleLabel)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        tableApperance()
        buttonsActions()
        
        payButton.addTarget(self, action: #selector(payButtonAction), for: .touchUpInside)
        
        if UserSettings.adress != nil {
            locationTextField.text = "\(UserSettings.adress[0][0].adress)"
        }
        
        checkBasket()
        
    }
    
    @objc
    func payButtonAction() {
    
        
        if UserSettings.activeOrder == false {
            if isProductsInStock {
                refreshingBasket()
            } else {
                sendDataToServer(orders: basketInfo)
            }
        } else {
            displayOrderAlert()
        }
    }
    
    func refreshingBasket() {

        if isProductsInStock == true {
            if locationTextField.hasText == true {
                if UserSettings.activeOrder == false {
                    
           
                    UserSettings.orderSum = totalBasketPrice
                    //UserSettings.orderInfo = ba
                    
                    //UserSettings.basketProdQuant = 0
                    
                    UserSettings.orderInfo = basketInfo
                    sendDataToServer(orders: basketInfo)
              
                    
                    UserSettings.basketInfo = []
                    basketProdData = []
                    basketInfo = []
                    
                    tableView.reloadData()
                    NotificationCenter.default.post(name: NSNotification.Name("OrderPaid"), object: nil)
                    UserSettings.orderPaid = true
                    //UserSettings.activeOrder = true
                    UserSettings.isLocChanging = true
                    NotificationCenter.default.post(name: NSNotification.Name("orderPaid"), object: nil)
                    dismiss(animated: true)
                    
                } else {
                    displayOrderAlert()
                }
            } else {
                displaySaveError()
            }
        } else {
            //displayBasketAlert()
        }
    }
    
    func checkBasket() {
   
    }
    
    //MARK: - Back: send order Info To Server bbb
    func sendDataToServer(orders: [[BasketInfo]]) {
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
            if error != nil {
                return
            } else if let data = data {
                //guard let data = data else { return }
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let unavailableProducts = jsonResponse["unavailable_items"] as? [Int],
                       let isProductsAvailable = jsonResponse["success"] as? Bool {
                       
                        
                        if isProductsAvailable {
                            self.isProductsInStock = true
                        } else {
                            self.unavailableProducts = []
                     
                            self.unavailableInd = unavailableProducts
                            
                            for i in 1...self.basketInfo.count {
                                //if self.unavailableProducts.count != 0 {
                                for u in self.unavailableInd {
                                    if self.basketInfo[i-1][0].id == u {
                                        self.unavailableProducts.append(self.basketInfo[i-1])
                                    } else {
                                        
                                    }
                                }
                            }
                            
                            
                            DispatchQueue.main.async {
                                self.prodToDel = self.unavailableProducts
                                self.displayBasketAlert()
                                //self.unavailableProducts = []
                            }
                        }
                    } else {
                        self.isProductsInStock = true
                    }
                    
                } catch {
                }
                
                if let response = response as? HTTPURLResponse, response.statusCode == 201 {
                    
                    
                } else {
                }
                
            }
        }
        task.resume()
    }
    
    func displayBasketAlert() {
        var products = ""
        for i in 0...self.unavailableProducts.count-1 {
            products += " \(self.unavailableProducts[i][0].title)"
        }
      
        let alertController = UIAlertController(title: "Готово", message: "Товаров нет в наличии: \(products)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
        
        
    }
    
    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func tableApperance() {
        
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.backgroundColor = R.Colors.background
        self.tableView.estimatedRowHeight = 150
        self.tableView.allowsSelection = true
        self.tableView.isEditing = false
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.register(BasketCell.self, forCellReuseIdentifier: BasketCell.id)
        
        view.addSubview(tableView)
        view.addSubview(basketImage)
        basketConfig()
    }
    
    func buttonsActions() {
        locationButton.addTarget(self, action: #selector(locationButtonAction), for: .touchUpInside)
        saveLocationButton.addTarget(self, action: #selector(saveLocationButtonAction), for: .touchUpInside)
    }
    
    @objc
    func saveLocationButtonAction() {
        if UserSettings.isLocChanging == false {
            adress = locationTextField.text!
            view.endEditing(true)
            if locationTextField.text != nil {
                searchForAddress(locationTextField.text!)
            } else {
                displaySaveError()
            }
            displayAddressAlert(address: "")
        } else {
            displayLocSaveError()
        }
    }
    
    @objc
    func locationButtonAction() {
        let addressPickerVC = AddressPickerViewController()
        addressPickerVC.delegate = self
        present(addressPickerVC, animated: true, completion: nil)
    }
    
    func addressDidPick(_ address: String) {
        locationButton.setTitle(address, for: .normal)
    }
    
    
    //--MARK: Alerts
    func displayAddressAlert(address: String) {
        let alertController = UIAlertController(title: "Готово", message: "Адрес доставки сохранен", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    func displaySaveError() {
        let alertController = UIAlertController(title: "Ошибка", message: "Введите адрес доставки", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    func displayLocSaveError() {
        let alertController = UIAlertController(title: "Ошибка", message: "Дождитесь завершения заказа и введите адрес еще раз", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    func displayOrderAlert() {
        let alertController = UIAlertController(title: "Обработка", message: "Дождитесь завершения предыдущего заказа", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    
    func searchForAddress(_ address: String) {
        print("address = \(adress)")
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("г. Владикавказ, ул.\(adress)") { [weak self] (placemarks, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                return
            }
            if let placemark = placemarks?.first, let location = placemark.location {
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
                
                //strongSelf.mapView.setRegion(region, animated: true)
                
                
                UserSettings.adress = []
                UserSettings.adress.append([])
                UserSettings.adress[0].append(.init(adress: self!.adress, latitude: region.center.latitude, longitude: region.center.longitude))
                
            }
        }
    }
    
    func basketRefresh() {
        basketProdData = []
        basketInfo = UserSettings.basketInfo ?? []
        var indexesToDelete: [Int] = []
        for (index, el) in basketInfo.enumerated() {
            if el.isEmpty {
                indexesToDelete.append(index)
            } else if el[0].quantity == 0 {
                indexesToDelete.append(index)
            }
        }
        for index in indexesToDelete.reversed() {
            basketInfo.remove(at: index)
        }
        
       
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)
        
        basketInfo = basketInfo.sorted { $0.count < $1.count }
        if basketInfo.count > 0 {
            for i in 0...basketInfo.count-1 {
                basketProdData.append(.init(title: basketInfo[i][0].title, quantity: basketInfo[i][0].quantity, price: Int(basketInfo[i][0].price), id: basketInfo[i][0].id, time: dateString))
            }
        } else {
            basketProdData = []
        }
//        totalLabelSum.text = "\(totalBasketPrice)"
//        self.pricesView = PricesView(totalSum: totalBasketPrice)
//        view.addSubview(pricesView)
        tableView.reloadData()
        
        if basketProdData.isEmpty {
            basketImage.alpha = 1
            pricesView.alpha = 0
            payButton.alpha = 0
        } else {
            basketImage.alpha = 0
            payButton.alpha = 1
            pricesView.alpha = 1
        }
    }
    
    func basketConfig() {
        basketProdData = []
        basketInfo = UserSettings.basketInfo ?? []
        var indexesToDelete: [Int] = []
        for (index, el) in basketInfo.enumerated() {
            if el.isEmpty {
                indexesToDelete.append(index)
            } else if el[0].quantity == 0 {
                indexesToDelete.append(index)
            }
        }
        for index in indexesToDelete.reversed() {
            basketInfo.remove(at: index)
        }
        
        prices = prices.sorted { $0.count > $1.count }
        
       
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)
        
        basketInfo = basketInfo.sorted { $0.count < $1.count }
        if basketInfo.count > 0 {
            for i in 0...basketInfo.count-1 {
                basketProdData.append(.init(title: basketInfo[i][0].title, quantity: basketInfo[i][0].quantity, price: Int(basketInfo[i][0].price), id: basketInfo[i][0].id, time: dateString))
                
                totalBasketPrice += basketInfo[i][0].price * Double(basketInfo[i][0].quantity)
                
                
            }
        } else {
            basketProdData = []
        }
        totalLabelSum.text = "\(totalBasketPrice)"
        self.pricesView = PricesView(totalSum: totalBasketPrice)
        view.addSubview(pricesView)
        tableView.reloadData()
        
        if basketProdData.isEmpty {
            basketImage.alpha = 1
            pricesView.alpha = 0
            payButton.alpha = 0
        } else {
            basketImage.alpha = 0
            payButton.alpha = 1
            pricesView.alpha = 1
        }
        
        //
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor,constant: 120),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -256),
            
            pricesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pricesView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            pricesView.widthAnchor.constraint(equalToConstant: view.bounds.width - 48),
            pricesView.heightAnchor.constraint(equalToConstant: 100),
            
            basketImage.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            basketImage.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            basketImage.heightAnchor.constraint(equalToConstant: 120),
            basketImage.widthAnchor.constraint(equalToConstant: 120),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            locationImage.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            locationImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            locationImage.heightAnchor.constraint(equalToConstant: 30),
            locationImage.widthAnchor.constraint(equalTo: locationImage.heightAnchor),
            
            saveLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            saveLocationButton.centerYAnchor.constraint(equalTo: locationImage.centerYAnchor),
            saveLocationButton.heightAnchor.constraint(equalToConstant: 40),
            saveLocationButton.widthAnchor.constraint(equalTo: saveLocationButton.heightAnchor),
            
            locationTextField.leadingAnchor.constraint(equalTo: locationImage.trailingAnchor, constant: 8),
            locationTextField.centerYAnchor.constraint(equalTo: locationImage.centerYAnchor),
            
            payButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -64),
            payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            payButton.widthAnchor.constraint(equalToConstant: view.bounds.width-128),
            payButton.heightAnchor.constraint(equalToConstant: 64),
        ])
    }
    
    func priceViewApperance(totalPrice: Double) {
        self.pricesView = PricesView(totalSum: totalPrice)
        view.addSubview(pricesView)
        
        NSLayoutConstraint.activate([
            pricesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pricesView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            pricesView.widthAnchor.constraint(equalToConstant: view.bounds.width - 48),
            pricesView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}

extension BasketController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        basketProdData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasketCell.id, for: indexPath) as! BasketCell
        var basketData = self.basketProdData[indexPath.row]
        
        if basketData.quantity != 0 {
            for el in self.storeProducts {
                if el["name"] as? String == basketData.title {
                    if let productCount = el["quantity"] as? Int {
                        if basketData.quantity == productCount {
                            cell.config(title: basketData.title, quantity: basketData.quantity, price: basketData.price, inStock: false)
                            tableView.reloadRows(at: [indexPath], with: .none)
                        } else {
                            cell.config(title: basketData.title, quantity: basketData.quantity, price: basketData.price, inStock: true)
                            tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
            }
        }
        

        
        cell.baskMinusTap = {
            print("#BasketController#cell.baskMinusTap-START-#BasketInfo = \(UserSettings.basketInfo ?? [])")
            if basketData.quantity != 0 {
                basketData.quantity -= 1
             
                for i in 1...self.basketInfo.count {
                    for el in self.basketInfo[i-1] {
                        if el.title == basketData.title {
                          
                            self.basketInfo[i-1][0].quantity -= 1
                            self.totalBasketPrice = self.totalBasketPrice - self.basketInfo[i-1][0].price
                            self.totalLabelSum.text = "\(self.totalBasketPrice)"
                            self.pricesView.removeFromSuperview()
                            self.priceViewApperance(totalPrice: self.totalBasketPrice)
        
                            break
                        }
                    }
                }
                
                outerLoop: for _ in UserSettings.basketInfo {
                    for ind in 0...UserSettings.basketInfo.count-1 {
                        if UserSettings.basketInfo[ind].isEmpty == false {
                            //print("ind = \(ind)")
                            if UserSettings.basketInfo[ind][0].title == basketData.title {
                                
                                print("ind = \(ind)")
                                print("UserSettings.basketInfo[ind][0].title = \(UserSettings.basketInfo[ind][0].title)")
                                print("basketData.title = \(basketData.title)")
                                UserSettings.basketInfo[ind][0].quantity -= 1
                               
                                
                                break outerLoop // Выход из обоих циклов
                            }
                        }
                    }
                }
                
                for el in self.storeProducts {
                    if el["name"] as? String == basketData.title {
                        if let productCount = el["quantity"] as? Int {
                            if basketData.quantity == productCount {
                                cell.config(title: basketData.title, quantity: basketData.quantity, price: basketData.price, inStock: false)
                                //tableView.reloadRows(at: [indexPath], with: .none)
                            } else {
                                cell.config(title: basketData.title, quantity: basketData.quantity, price: basketData.price, inStock: true)
                                //tableView.reloadRows(at: [indexPath], with: .none)
                            }
                        }
                    }
                }
            }
            
            if basketData.quantity == 0 {
                self.basketInfo[indexPath.row] = []
                UserSettings.deletedFromBasketNow = true
                self.basketProdData.remove(at: indexPath.row)
                outerLoop2: for _ in UserSettings.basketInfo {
                    for ind in 0...UserSettings.basketInfo.count-1 {
                        if UserSettings.basketInfo[ind].isEmpty == false {
                            //print("ind = \(ind)")
                            if UserSettings.basketInfo[ind][0].title == basketData.title {
                                UserSettings.basketInfo[ind] = []
                                NotificationCenter.default.post(name: NSNotification.Name("prodDeleted"), object: nil)
                                break outerLoop2 // Выход из обоих циклов
                            }
                        }
                    }
                }
                //self.basketConfig()
                self.basketRefresh()
                
            }
            NotificationCenter.default.post(name: NSNotification.Name("basketUpdated"), object: nil)
            print("#BasketController#cell.baskMinusTap-END-#BasketInfo = \(UserSettings.basketInfo ?? [])")
        }
        
        cell.baskPlusTap = {
            
            print("#BasketController#cell.baskPlusTap-START-#BasketInfo = \(UserSettings.basketInfo ?? [])")
            basketData.quantity += 1
            self.basketInfo[indexPath.row][0].quantity += 1
            self.totalBasketPrice = self.totalBasketPrice + self.basketInfo[indexPath.row][0].price
            self.totalLabelSum.text = "\(self.totalBasketPrice)"
            self.pricesView.removeFromSuperview()
            self.priceViewApperance(totalPrice: self.totalBasketPrice)
            
            outerLoop: for el in UserSettings.basketInfo {
                for ind in 0...UserSettings.basketInfo.count-1 {
                    if UserSettings.basketInfo[ind].isEmpty == false {
                        print("el = \(el)")
                        //print("ind = \(ind)")
                        if UserSettings.basketInfo[ind][0].title == basketData.title {
                            print("ind = \(ind)")
                            print("UserSettings.basketInfo[ind][0].title = \(UserSettings.basketInfo[ind][0].title)")
                            print("basketData.title = \(basketData.title)")
                            UserSettings.basketInfo[ind][0].quantity += 1
                            print("\(UserSettings.basketInfo[ind][0])")
                            break outerLoop // Выход из обоих циклов
                        }
                    }
                }
            }
            
            print("#outerLoop#UserSettings.basketInfo = \(UserSettings.basketInfo ?? [])")
            
            
            for el in self.storeProducts {
                if el["name"] as? String == basketData.title {
                    if let productCount = el["quantity"] as? Int {
                        if basketData.quantity == productCount {
                            cell.config(title: basketData.title, quantity: basketData.quantity, price: basketData.price, inStock: false)
                            //tableView.reloadRows(at: [indexPath], with: .none)
                        } else {
                            cell.config(title: basketData.title, quantity: basketData.quantity, price: basketData.price, inStock: true)
                            //tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name("basketUpdated"), object: nil)
            print("#BasketController#cell.baskPlusTap-END-#BasketInfo = \(UserSettings.basketInfo ?? [])")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("#BasketController#editingStyle =.delete#basketInfo = \(UserSettings.basketInfo ?? [])")
            let basketData = self.basketProdData[indexPath.row]
            UserSettings.basketInfo[basketData.id][0].inBasket = true
            
            
            var bskt = UserSettings.basketInfo
            var prodToDel = UserSettings.unavailableProducts
            
            if prodToDel!.isEmpty == false {
                for i in 0...prodToDel!.count-1 {
                    if prodToDel!.count > i {
                        for _ in prodToDel![i] {
                           
                            prodToDel!.removeAll { sublist in
                                sublist.contains(where: { $0.id == basketData.id })
                            }
                            
                            bskt!.removeAll { sublist in
                                sublist.contains(where: { $0.id == basketData.id })
                            }
                        }
                    }
                }
            }
            UserSettings.unavailableProducts = prodToDel
            self.unavailableProducts = prodToDel!
        
            UserSettings.basketProdQuant -= UserSettings.basketInfo[basketData.id][0].quantity
            basketInfo.remove(at: indexPath.row)
            
            print("#BasketController#editingStyle =.delete#basketProdData[indexPath.row].price = \(basketProdData[indexPath.row].price)")
            print("#BasketController#editingStyle =.delete#basketProdData[indexPath.row].quantity = \(basketProdData[indexPath.row].quantity)")
            
            outerLoop: for el in UserSettings.basketInfo {
                for ind in 0...UserSettings.basketInfo.count-1 {
                    if UserSettings.basketInfo[ind].isEmpty == false {
                        print("el = \(el)")
                        //print("ind = \(ind)")
                        if UserSettings.basketInfo[ind][0].title == basketData.title {
                            if UserSettings.basketInfo[ind][0].quantity == 1 {
                                self.totalBasketPrice = totalBasketPrice - UserSettings.basketInfo[ind][0].price
                                UserSettings.basketInfo[ind][0].quantity = 0
                                self.pricesView.removeFromSuperview()
                                priceViewApperance(totalPrice: self.totalBasketPrice)
                                totalLabelSum.text = "\(self.totalBasketPrice)"
                                break outerLoop
                            } else {
                                totalBasketPrice = totalBasketPrice - Double(UserSettings.basketInfo[ind][0].price) * Double(UserSettings.basketInfo[ind][0].quantity)
                                UserSettings.basketInfo[ind][0].quantity = 0
                                self.pricesView.removeFromSuperview()
                                priceViewApperance(totalPrice: self.totalBasketPrice)
                                totalLabelSum.text = "\(self.totalBasketPrice)"
                                break outerLoop
                            }// Выход из обоих циклов
                        }
                    }
                }
            }
            
            
            
            //basketData.id
            
            //UserSettings.basketInfo[basketData.id][0].quantity = 0
            basketProdData.remove(at: indexPath.row)
            
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            
            if totalBasketPrice == 0 {
                basketImage.alpha = 1
                pricesView.alpha = 0
                payButton.alpha = 0
            } else {
                basketImage.alpha = 0
                payButton.alpha = 1
                pricesView.alpha = 1
            }
            
            NotificationCenter.default.post(name: NSNotification.Name("basketUpdated"), object: nil)
            
            if prodToDel!.isEmpty {
                isProductsInStock = true
            }
            self.basketRefresh()
            //tableView.reloadData()
        }
       // tableView.reloadData()
    }
}
