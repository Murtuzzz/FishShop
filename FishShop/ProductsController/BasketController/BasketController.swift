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

class BasketController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var basketProdData: [Basket] = []
    
    private var tableView = UITableView()
    private var basketProdCount = 0
    private var totalBasketPrice = 0.0
    private var userBasket = [[String]]()
    private var prices = [[Int]]()
    var onDeleteTap:((String) -> Void)?
    private var basketInfo = [[BasketInfo]]()
    
    private var flag = true
    
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
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = R.Fonts.avenirBook(with: 32)
        return label
    }()
    
    private var cardsData:[CardInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.background
        view.addSubview(basketView)
        view.addSubview(basketButton)
        view.addSubview(profileView)
        view.addSubview(totalLabel)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        tableApperance()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("-------------------------------------------------------")
        print("Basket info = \(basketInfo)")
        print("BasketData = \(UserSettings.basketInfo)")
        //basketConfig()
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
        basketConfig()
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor,constant: 128),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -256),
            
            totalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            totalLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 24),
            
        ])
        
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
            totalLabel.text = "\(totalBasketPrice)"
        tableView.reloadData()
        print("Basket info MID = \(basketInfo)")
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
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //print("UserSettings len = \(UserSettings.basketInfo.count) and basketProd = \(basketProdData.count)")
            
            let basketData = self.basketProdData[indexPath.row]
            UserSettings.basketInfo[basketData.id][0].inBasket = true
            UserSettings.basketInfo[basketData.id][0].quantity = 0
            basketInfo.remove(at: indexPath.row)
//            if UserSettings.basketInfo.isEmpty == false {
//                UserSettings.basketInfo[basketData.id][0].inBasket = true
//                UserSettings.basketInfo[basketData.id][0].quantity = 0
////                if UserSettings.basketInfo[basketData.id].isEmpty == false {
////
////                }
//            }
            //print("UserSettig Basket == \(UserSettings.basketInfo)")
            
            // Удаляем данные из источника данных
            totalBasketPrice = totalBasketPrice - Double((basketProdData[indexPath.row].price * basketProdData[indexPath.row].quantity))
            //onDeleteTap?(basketProdData[indexPath.row].title)
            basketProdData.remove(at: indexPath.row)
         
            tableView.deleteRows(at: [indexPath], with: .fade)
            //print("indexPath = \(indexPath.row)")
            totalLabel.text = "\(totalBasketPrice)"
            
            tableView.reloadData()
            
            NotificationCenter.default.post(name: NSNotification.Name("basketUpdated"), object: nil)
        }
        
        print("Basket info after all = \(basketInfo)")
        print("BasketData After All = \(UserSettings.basketInfo)")
    }

}


