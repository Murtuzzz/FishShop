//
//  TestCollection.swift
//  FishShop
//
//  Created by Мурат Кудухов on 29.03.2024.
//

struct CardInfo {
    let image: String
    let price: String
    let title: String
    let prodType: ProdType
    let prodId: Int
    var prodCount: Int = 0
    var isInBasket: Bool = false
}

import UIKit

class ProductsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView = UITableView()

    
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
//    private let buttons = FilterButtons()
//   
//    private var selectedFilter: ProdFilter = .all
//    private var displayDataSource: [CardInfo] {
//        switch selectedFilter {
//        case .all:
//            return cardsData
//        case .frozen:
//            return cardsData.filter { item in
//                return item.prodType == .frozen
//            }
//        case .salmon:
//            return cardsData.filter { item in
//                return item.prodType == .salmon
//            }
//        }
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.background
        UserSettings.basket = [:]
        //view.addSubview(buttons)
        view.addSubview(basketView)
        view.addSubview(basketButton)
        view.addSubview(profileView)
        title = "Products"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        constraints()
        buttonActions()
        tableApperance()
    }
    
    func buttonActions() {
        basketButton.addTarget(self, action: #selector(basketAction), for: .touchUpInside)
        
    }
    
    @objc
    func basketAction() {
        let vc = BasketController()
        present(vc, animated: true)
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
        
        self.tableView.register(ProductsTableCell.self, forCellReuseIdentifier: ProductsTableCell.id)
        
        view.addSubview(tableView)
        
        //buttons.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 144),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
//            buttons.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -8),
//            buttons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
        
        cardsData = [.init(image: "salmon", price: "1.990 р", title: "Tasty salmon", prodType: .salmon, prodId: 1),
                     .init(image: "dish", price: "1.990 р", title: "Grilled fish", prodType: .salmon, prodId: 2,prodCount: 6),
                     .init(image: "fish2", price: "1.990 р", title: "Tasty frozen fish", prodType: .frozen, prodId: 3),
                     .init(image: "fish3", price: "1.990 р", title: "dd", prodType: .frozen, prodId: 4),
                     .init(image: "fish", price: "1.990 р", title: "dd", prodType: .salmon, prodId: 8),
                     .init(image: "salmon", price: "1.990 р", title: "Tasty salmon", prodType: .salmon, prodId: 1),
                                  .init(image: "dish", price: "1.990 р", title: "Grilled fish", prodType: .salmon, prodId: 2),
                                  .init(image: "fish2", price: "1.990 р", title: "Tasty frozen fish", prodType: .frozen, prodId: 3),
                                  .init(image: "fish3", price: "1.990 р", title: "dd", prodType: .frozen, prodId: 4),
                                  .init(image: "fish", price: "1.990 р", title: "dd", prodType: .salmon, prodId: 8)]
        
//        buttons.onFilterChange = { newFilter in
//            self.selectedFilter = newFilter
//            self.tableView.reloadData()
//        }
        
    }
    
    func constraints() {
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
        ])
    }
}

extension ProductsController: CellDelegate, BasketCellDelegate {
    func didTapBasketButton(inCell cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        cardsData[indexPath.row].isInBasket.toggle()
        tableView.reloadRows(at: [indexPath], with: .none)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cardsData.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableCell.id, for: indexPath) as! ProductsTableCell
        cell.delegate = self
        let cellData = cardsData[indexPath.row]
        
        cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title, title: cellData.title, prodId: cellData.prodId, prodCount: cellData.prodCount, isInBasket: cellData.isInBasket)
        
        cell.buttonClicked = { [self] in
            self.openVc(indexPath.row)
            print(indexPath.row)
        }
        
        
        cell.onPlusTap = {
            self.cardsData[indexPath.row].prodCount += 1
            DispatchQueue.main.async {
                cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                title: cellData.title, prodId: cellData.prodId,
                                prodCount: self.cardsData[indexPath.row].prodCount, isInBasket: cellData.isInBasket)
                tableView.reloadRows(at: [indexPath], with: .none)
                print("\(self.cardsData[indexPath.row].prodCount) PLUS")
            }
        }
        
        
            
        cell.onMinusTap = {
            if self.cardsData[indexPath.row].prodCount > 0 {
                self.cardsData[indexPath.row].prodCount -= 1
                DispatchQueue.main.async {
                    cell.cellConfig(img: cellData.image, price: cellData.price, name: cellData.title,
                                    title: cellData.title, prodId: cellData.prodId,
                                    prodCount: self.cardsData[indexPath.row].prodCount, isInBasket: cellData.isInBasket)
                    tableView.reloadRows(at: [indexPath], with: .none)
                    print("\(self.cardsData[indexPath.row].prodCount) MINUS")
                }
            }
        }

        return cell
        
    
    }
    
    func openVc(_ index: Int) {
        
        //let cellData = displayDataSource[index]
        
        //navigationController?.pushViewController(CardInfoController(title: cellData.title, image: cellData.image), animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("CELL")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = view.bounds.height
        return height/2.65
        
      }
    
    func infoButtonTapped(cell: UITableViewCell) {
        guard tableView.indexPath(for: cell) != nil else { return }
        //let vc = CardInfoController()
        
        //present(CardInfoController(), animated: true)
//        navigationController?.pushViewController(vc, animated: true)
    }
}


