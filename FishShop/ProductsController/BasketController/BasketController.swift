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
}


import UIKit

class BasketController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var basketProdData: [Basket] = []
    
    private var tableView = UITableView()
    private var basketProdCount = 0
    var userBasket = [[String]]()
    
    var flag = true
    
    private let basketView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.barBg.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
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
    
    private var cardsData:[CardInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.background
        view.addSubview(basketView)
        view.addSubview(basketButton)
        view.addSubview(profileView)
        title = "Products"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        //basketConfig()
        tableApperance()
        
    }
    
    func tableApperance() {
        
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.backgroundColor = R.Colors.background
        self.tableView.estimatedRowHeight = 150
        self.tableView.allowsSelection = false
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.register(BasketCell.self, forCellReuseIdentifier: BasketCell.id)
        basketConfig()
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
        
    }
    
    func basketConfig() {
        var userBasket = [[String]]()
        if var basket = UserSettings.basket {
            for (key,value) in basket {
                if let array = value as? NSArray, array.count == 0 {
                    basket.removeValue(forKey: key)
                } else if let arrayValue = value as? NSArray {
                    let newArray = Array(arrayValue) as? [String] ?? []
                    userBasket.append(newArray)
                }
            }
//            print("basketConfig = \(basket)")
//            print("userBasket = \(userBasket)")
            if userBasket.count > 0 {
                for i in 0...userBasket.count-1 {
                    print(userBasket[i][0])
                    basketProdData.append(.init(title: userBasket[i][0], quantity: userBasket[i].count))
                }
            } else {
                basketProdData = []
            }
        }
        tableView.reloadData()
    }
}

extension BasketController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        basketProdData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasketCell.id, for: indexPath) as! BasketCell
        
        
        let basketData = self.basketProdData[indexPath.row]
        cell.config(title: basketData.title, quantity: basketData.quantity)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("CELL")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = view.bounds.height
        return 50
        
    }
}


