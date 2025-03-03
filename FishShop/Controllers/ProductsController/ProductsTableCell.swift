//
//  ProductsTableCell.swift
//  FishShop
//
//  Created by Мурат Кудухов on 08.03.2024.
//

import UIKit

protocol CellDelegate: AnyObject {
    func infoButtonTapped(cell: UITableViewCell)
}

protocol BasketCellDelegate: AnyObject {
    func didTapBasketButton(inCell cell: UITableViewCell)
}

final class ProductsTableCell: UITableViewCell {
    
    static var id = "ProductsTableCell"
    
    private var prodId = 0
    private var prodCount = 0
    
    private var minBasketWidth: CGFloat = 40
    private var basketViewWidth: NSLayoutConstraint? = nil
    private var activeTimer: Timer?
    private var inactiveTimer: Timer?
    private var condition = false
    var bskt: [[BasketInfo]] = []
    
    var buttonClicked: (() -> Void)?
    var onPlusTap: (() -> Void)?
    var onMinusTap: (() -> Void)?
    
    weak var cellDelegate: CellDelegate?
    weak var basketDelegate: BasketCellDelegate?
    
    private let basketView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = .gray.withAlphaComponent(0.5)
        view.layer.masksToBounds = true
        view.backgroundColor = .gray.withAlphaComponent(0.5)
        view.layer.cornerRadius = 20
        //view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = .gray.withAlphaComponent(0.5)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        //view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let container: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        //view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "fish")
        return view
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "2.990 p"
        label.backgroundColor = .gray.withAlphaComponent(0.5)
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = R.Fonts.trebuchet(with: 22)
        label.textAlignment = .center
        return label
    }()
    
    private var prodCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = R.Fonts.trebuchet(with: 22)
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Fresh frozen fish"
        //label.backgroundColor = .gray.withAlphaComponent(0.5)
        //label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = R.Fonts.trebuchet(with: 22)
        label.textAlignment = .center
        return label
    }()
    
    private let basketButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "basket"), for: .normal)
        button.backgroundColor = .gray.withAlphaComponent(0.5)
        button.layer.cornerRadius = 20
        button.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 20
        button.alpha = 0
        button.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 20
        button.alpha = 0
        button.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.contentMode = .scaleAspectFit
        button.tintColor = .black
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bskt = UserSettings.basketInfo
        addSubview(container)
        addSubview(priceLabel)
        addSubview(titleView)
        addSubview(titleLabel)
        addSubview(basketView)
        addSubview(prodCountLabel)
        contentView.addSubview(removeButton)
        contentView.addSubview(addButton)
        contentView.addSubview(infoButton)
        blurEffect(someView: titleView)
        buttonsAction()
        
        contentView.addSubview(basketButton)
        constraints()
        backgroundColor = R.Colors.background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkProd() {
        for (listIndex, list) in bskt.enumerated() { // Итерация по каждому подмассиву
            if let itemIndex = list.firstIndex(where: { $0.title == self.titleLabel.text }) { // Пытаемся найти индекс элемента
                if bskt[listIndex][itemIndex].quantity != 0 {
                    basketButton.alpha = 0
//                    if bskt[listIndex][itemIndex].inStock {
//                        addButton.alpha = 1
//                    } else {
//                        addButton.alpha = 0
//                    }
                    removeButton.alpha = 1
                    prodCountLabel.alpha = 1
                    basketView.alpha = 1
                } else {
                    basketButton.alpha = 1
                    addButton.alpha = 0
                    removeButton.alpha = 0
                    prodCountLabel.alpha = 0
                    basketView.alpha = 0
                }
                
                if bskt[listIndex][itemIndex].inStock == false {
                    addButton.alpha = 0
                } else {
                    addButton.alpha = 1
                }
                
                break
            }
        }
    }
    
    func cellConfig(img: String, price: Int, name: String, title: String, prodId: Int, prodCount: Int, isInBasket: Bool, wasInBasket: Bool, inStock: Bool) {
        container.image = UIImage(named: img)
        priceLabel.text = "\(price) р"
        titleLabel.text = title
        prodCountLabel.text = "\(prodCount)"
        
        // Обновляем кнопки
        if prodCount == 0 {
            addButton.alpha = 0
        } else {
            if inStock == false {
                addButton.alpha = 0
            } else {
                addButton.alpha = 1
            }
        }
        
        //addButton.alpha = inStock ? 1 : 0
        basketButton.alpha = prodCount > 0 ? 0 : 1
        removeButton.alpha = prodCount > 0 ? 1 : 0
        prodCountLabel.alpha = prodCount > 0 ? 1 : 0
        
        basketView.alpha = prodCount > 0 ? 1 : 0
        
       
        
//        if inStock == false {
//            addButton.alpha = 0
//        } else {
//            addButton.alpha = 1
//        }
//        
//        checkProd()
//        if prodCount != 0 {
//            basketButton.alpha = 0
//            //addButton.alpha = 1
//            removeButton.alpha = 1
//            prodCountLabel.alpha = 1
//            basketView.alpha = 1
//        } else {
//            basketButton.alpha = 1
//            addButton.alpha = 0
//            removeButton.alpha = 0
//            prodCountLabel.alpha = 0
//            basketView.alpha = 0
//        }

    }
    
    func buttonsAction() {
        infoButton.addTarget(self, action: #selector(infoButtonAction), for: .touchUpInside)
        basketButton.addTarget(self, action: #selector(basketButtonAction), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeButtonAction), for: .touchUpInside)
        
    }
    
    @objc func basketButtonAction() {
        basketDelegate?.didTapBasketButton(inCell: self)
    }
    
    @objc
    func addButtonAction() {
        onPlusTap?()
        
    }
    
    @objc
    func removeButtonAction() {
        onMinusTap?()
        
    }
    
    //MARK: - BasketAction
    
    @objc
    func infoButtonAction() {
        buttonClicked?()
        //delegate?.infoButtonTapped(cell: self)

    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            container.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            priceLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            priceLabel.heightAnchor.constraint(equalToConstant: 36),
            priceLabel.widthAnchor.constraint(equalToConstant: 104),
            
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 16),
            
            titleView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            titleView.heightAnchor.constraint(equalToConstant: 48),
            titleView.widthAnchor.constraint(equalToConstant: bounds.width - 16),
            
            basketButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            basketButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            basketButton.heightAnchor.constraint(equalToConstant: 40),
            basketButton.widthAnchor.constraint(equalTo: basketButton.heightAnchor),
            
            addButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 40),
            addButton.widthAnchor.constraint(equalTo: basketButton.heightAnchor),
            
            prodCountLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8),
            prodCountLabel.centerYAnchor.constraint(equalTo: basketButton.centerYAnchor),
            
            removeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            removeButton.trailingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: -72),
            removeButton.heightAnchor.constraint(equalToConstant: 40),
            removeButton.widthAnchor.constraint(equalTo: basketButton.heightAnchor),
            
            basketView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            basketView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            //basketView.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            basketView.heightAnchor.constraint(equalToConstant: 40),
            basketView.widthAnchor.constraint(equalToConstant: 110),
            
            infoButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -8),
            infoButton.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            infoButton.heightAnchor.constraint(equalToConstant: 32),
            infoButton.widthAnchor.constraint(equalTo: infoButton.heightAnchor)
            
        ])
        
    }
    
}
extension ProductsTableCell {
    func blurEffect(someView: UIView) {
        // Создание объекта `UIBlurEffect` со стилем эффекта.
            // .extraLight, .light, .dark, .regular и .prominent - на выбор в зависимости от желаемого эффекта.
        let blurEffect = UIBlurEffect(style: .dark)
        
            // Создание объекта `UIVisualEffectView`, который будет использовать `blurEffect`.
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //blurEffectView.alpha = 0.9
        blurEffectView.frame = someView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        someView.addSubview(blurEffectView)
    }
}
