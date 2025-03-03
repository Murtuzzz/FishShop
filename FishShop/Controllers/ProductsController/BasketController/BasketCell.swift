//
//  BasketCell.swift
//  FishShop
//
//  Created by Мурат Кудухов on 05.04.2024.
//

import UIKit

final class BasketCell: UITableViewCell {
    
    static var id = "BasketCell"
    var prodCount = 0
    var baskMinusTap: (() -> Void)?
    var baskPlusTap: (() -> Void)?
    var bskt: [[BasketInfo]] = []
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.barBg
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = R.Fonts.avenirBook(with: 14)
        label.text = ""
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = R.Fonts.avenirBook(with: 18)
        label.text = ""
        return label
    }()
    
    private let prodImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        //button.backgroundColor = R.Colors.background.withAlphaComponent(0.5)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 9
        button.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.alpha = 1
        return button
    }()
    
    private let delButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        //button.backgroundColor = R.Colors.background.withAlphaComponent(0.5)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 9
        button.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.alpha = 1
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bskt = UserSettings.basketInfo
        addSubview(mainView)
        addSubview(prodImage)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(countLabel)
        contentView.addSubview(addButton)
        contentView.addSubview(delButton)
        backgroundColor = .clear
        buttonsActions()
        constraints()
        
        //setProdCountLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(title: String, quantity: Int, price: Int, inStock: Bool) {
        self.titleLabel.text = "\(title)"
        prodImage.image = UIImage(named: "\(title)")
        countLabel.text = "\(quantity)"
        priceLabel.text = "\(price) ₽"
        prodCount = quantity
        if inStock == false {
            addButton.alpha = 0
        } else {
            addButton.alpha = 1
        }
    }
    
    func buttonsActions() {
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        delButton.addTarget(self, action: #selector(delButtonAction), for: .touchUpInside)
    }
    
    func updateProdCount(in lists: inout [[BasketInfo]], newValue: Int) {
        for (listIndex, list) in lists.enumerated() {
            if let itemIndex = list.firstIndex(where: { $0.title == self.titleLabel.text }) {
                
                lists[listIndex][itemIndex].inBasket = true
                
                //lists[listIndex][itemIndex].quantity = newValue
                if newValue == 0 {
                    lists[listIndex] = []
                } else {
                    lists[listIndex][itemIndex].quantity = newValue
                } // Верно изменяем имя элемента
                break // После модификации выходим
            }
        }
    }
    
    @objc
    func delButtonAction() {
        baskMinusTap?()
        bskt = UserSettings.basketInfo
        print("   #BasketCell#delButtonAction_START_#BasketInfo = \(UserSettings.basketInfo ?? [])")
        print("   #BasketCell#delButtonAction_START_#bskt = \(bskt)")
        updateProdCount(in: &bskt, newValue: prodCount)
        UserSettings.basketInfo = bskt
        print("   #BasketCell#delButtonAction_END_#BasketInfo = \(UserSettings.basketInfo ?? [])")
        print("   #BasketCell#delButtonAction_END_#bskt = \(bskt)")
        UserSettings.basketProdQuant -= 1

    }
    
    @objc
    func addButtonAction() {
        baskPlusTap?()
        bskt = UserSettings.basketInfo
        print("   #BasketCell#addButtonAction_START_#BasketInfo = \(UserSettings.basketInfo ?? [])")
        print("   #BasketCell#addButtonAction_START_#bskt = \(bskt)")
        //prodCount += 1
        countLabel.text = "\(prodCount)"
        
        updateProdCount(in: &bskt, newValue: prodCount)
        UserSettings.basketProdQuant += 1
        UserSettings.basketInfo = bskt
        print("   #BasketCell#addButtonAction_END_#BasketInfo = \(UserSettings.basketInfo ?? [])")
        print("   #BasketCell#addButtonAction_END_#bskt = \(bskt)")
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: prodImage.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -8),
            titleLabel.widthAnchor.constraint(equalToConstant: bounds.width - 24),
            
            priceLabel.leadingAnchor.constraint(equalTo: prodImage.trailingAnchor, constant: 16),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            priceLabel.widthAnchor.constraint(equalToConstant: bounds.width - 24),
            
            prodImage.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            prodImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            prodImage.widthAnchor.constraint(equalToConstant: 80),
            prodImage.heightAnchor.constraint(equalToConstant: 80),
            
            countLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -40),
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.widthAnchor.constraint(equalToConstant: 50),
            countLabel.heightAnchor.constraint(equalToConstant: 24),
            
            addButton.leadingAnchor.constraint(equalTo: countLabel.trailingAnchor, constant: 8),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 20),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor),
            
            delButton.trailingAnchor.constraint(equalTo: countLabel.leadingAnchor, constant: -8),
            delButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            delButton.widthAnchor.constraint(equalToConstant: 20),
            delButton.heightAnchor.constraint(equalTo: delButton.widthAnchor),
            
            mainView.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            //mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}

