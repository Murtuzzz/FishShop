//
//  Basket.swift
//  FishShop
//
//  Created by Мурат Кудухов on 05.04.2024.
//

import UIKit

struct Basket {
    let title: String
    let quantity: Int
    let price: Int
    let id: Int
}

import UIKit

class BasketController: UIViewController, UITableViewDelegate, UITableViewDataSource,AddressPickerDelegate {
    
    var basketProdData: [Basket] = []
    
    private var tableView = UITableView()
    private var basketProdCount = 0
    private var totalBasketPrice = 0.0
    private var userBasket = [[String]]()
    private var prices = [[Int]]()
    var onDeleteTap:((String) -> Void)?
    private var basketInfo = [[BasketInfo]]()
    var pricesView = PricesView(totalSum: 0.0)
    
    private var flag = true
    
    private let basketView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.barBg.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
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
        button.setTitle(UserSettings.address ?? "г. Сосло, ул Щекера Берекера", for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .systemOrange
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
    
    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .systemOrange
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
        print(UserSettings.basketInfo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.background
        view.addSubview(basketView)
        view.addSubview(payButton)
        view.addSubview(locationButton)
        view.addSubview(locationImage)
        //view.addSubview(totalLabelSum)
        view.addSubview(titleLabel)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        tableApperance()
        buttonsActions()
    }
    
    func tableApperance() {
        
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.backgroundColor = R.Colors.background
        self.tableView.estimatedRowHeight = 150
        self.tableView.allowsSelection = false
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

    
    func basketConfig() {
        print("BasketConfig")
        basketInfo = UserSettings.basketInfo
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
            
            //print("userBasketCount = \(userBasket.count) basketInfoCount = \(basketInfo.count)")
            
            basketInfo = basketInfo.sorted { $0.count < $1.count }
            if basketInfo.count > 0 {
                for i in 0...basketInfo.count-1 {
                    basketProdData.append(.init(title: basketInfo[i][0].title, quantity: basketInfo[i][0].quantity, price: Int(basketInfo[i][0].price), id: basketInfo[i][0].id))
                    
                    totalBasketPrice += basketInfo[i][0].price * Double(basketInfo[i][0].quantity)
                    
                    //print("BASKET INFO in CONTR. Title =  \(basketInfo[i][0].title)")
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
            
            locationButton.leadingAnchor.constraint(equalTo: locationImage.trailingAnchor, constant: 8),
            //locationButton.widthAnchor.constraint(equalToConstant: 64),
            locationButton.centerYAnchor.constraint(equalTo: locationImage.centerYAnchor),
            
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
        let basketData = self.basketProdData[indexPath.row]
        
        if basketData.quantity != 0 {
            cell.config(title: basketData.title, quantity: basketData.quantity, price: basketData.price)
        }
        
        //print("UserSettig Basket == \(UserSettings.basketInfo)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("CELL")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let basketData = self.basketProdData[indexPath.row]
            UserSettings.basketInfo[basketData.id][0].inBasket = true
            for el in UserSettings.basketInfo[basketData.id] {
                print(el)
            }
           
            UserSettings.basketProdQuant -= UserSettings.basketInfo[basketData.id][0].quantity
            UserSettings.basketInfo[basketData.id][0].quantity = 0
            basketInfo.remove(at: indexPath.row)
        
            totalBasketPrice = totalBasketPrice - Double((basketProdData[indexPath.row].price * basketProdData[indexPath.row].quantity))

            basketProdData.remove(at: indexPath.row)
         
            tableView.deleteRows(at: [indexPath], with: .fade)
            //print("indexPath = \(indexPath.row)")
            totalLabelSum.text = "\(totalBasketPrice)"
            
            self.pricesView.removeFromSuperview()
            priceViewApperance(totalPrice: totalBasketPrice)
            if totalBasketPrice == 0 {
                basketImage.alpha = 1
                pricesView.alpha = 0
                payButton.alpha = 0
            } else {
                basketImage.alpha = 0
                payButton.alpha = 1
                pricesView.alpha = 1
            }
            
            tableView.reloadData()
            
            NotificationCenter.default.post(name: NSNotification.Name("basketUpdated"), object: nil)
        }
        
        //print("Basket info after all = \(basketInfo)")
        //print("BasketData After All = \(UserSettings.basketInfo)")
    }
}


