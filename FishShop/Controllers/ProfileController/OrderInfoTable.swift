//
//  OrderInfoTable.swift
//  FishShop
//
//  Created by Мурат Кудухов on 04.03.2025.
//

import UIKit

final class OrderInfoTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView = UITableView()
    private var orderData:[[BasketInfo]] = [[]]
    
    override func viewWillAppear(_ animated: Bool) {
        print("----------------------OrderInfoTable-------------------------------")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = R.Colors.background
        createTable()
        
        tableView.reloadData()
    }
    
    init(ind: Int) {
        super.init(nibName: nil, bundle: nil)
        
        title = UserSettings.ordersHistory[reversedIndex: ind]![0][0].orderTime
        
        if UserSettings.ordersHistory != nil {
            for el in UserSettings.ordersHistory[reversedIndex: ind]! {
                orderData[0].append(.init(title: el[0].title, price: el[0].price, quantity: el[0].quantity, id: el[0].id, inBasket: el[0].inBasket, catId: el[0].catId, inStock: el[0].inStock, prodCount: el[0].prodCount))
            }
            print("#OrderInfoTable#init#orderData = \(orderData)")
            print("OrderData.count = \(orderData[0].count)")
            
            tableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(ind: Int) {
        
    }
    
    func createTable() {
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = R.Colors.background
        self.tableView.isScrollEnabled = true
        self.tableView.allowsSelection = false
        self.tableView.backgroundColor = R.Colors.background
        self.tableView.layer.cornerRadius = 20
        self.tableView.register(ProfileOrderCell.self, forCellReuseIdentifier: ProfileOrderCell.id)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        tableView.reloadData()
//        profileData = [.init(title: "04.08.24", image: "Grilled fish"),
//                       .init(title: "03.08.24", image: "Grilled fish"),
//                       .init(title: "02.08.24", image: "Grilled fish"),
//                       .init(title: "01.08.24", image: "Grilled fish")]
    }
    
}

extension OrderInfoTable {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderData[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileOrderCell.id, for: indexPath) as! ProfileOrderCell
        
        print(orderData.count)
        let cellData = orderData[0][indexPath.row]
        
        
        
        cell.config(title: cellData.title, quantity: cellData.quantity, price: Int(cellData.price), orderTime: cellData.orderTime)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128.0
    }
    
}

extension Array {
    subscript(reversedIndex index: Int) -> Element? {
        get {
            if index == 0 {
                return self.last
            } else if index == self.count - 1 {
                return self.first
            } else if index >= 0 && index < self.count {
                return self[index]
            }
            return nil
        }
    }
}
