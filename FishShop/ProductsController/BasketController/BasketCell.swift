//
//  BasketCell.swift
//  FishShop
//
//  Created by Мурат Кудухов on 05.04.2024.
//

import UIKit

final class BasketCell: UITableViewCell {
    
    static var id = "BasketCell"
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.barBg
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.text = ""
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .gray
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(mainView)
        addSubview(prodImage)
        addSubview(titleLabel)
        addSubview(priceLabel)
        backgroundColor = .clear
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(title: String, quantity: Int, price: Int) {
        self.titleLabel.text = "\(title) количество: \(quantity)"
        prodImage.image = UIImage(named: "\(title)")
        priceLabel.text = "\(price) р"
    }
    
    
    func constraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: prodImage.trailingAnchor, constant: 24),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -16),
            titleLabel.widthAnchor.constraint(equalToConstant: bounds.width - 24),
            
            priceLabel.leadingAnchor.constraint(equalTo: prodImage.trailingAnchor, constant: 24),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 16),
            priceLabel.widthAnchor.constraint(equalToConstant: bounds.width - 24),
            
            prodImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            prodImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            prodImage.widthAnchor.constraint(equalToConstant: 72),
            prodImage.heightAnchor.constraint(equalToConstant: 72),
            
            mainView.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 8),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}

