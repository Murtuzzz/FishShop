//
//  ProfileOrderCell.swift
//  FishShop
//
//  Created by Мурат Кудухов on 04.09.2024.
//

import UIKit

final class ProfileOrderCell: UITableViewCell {
    
    static var id = "ProfileOrderCell"
    
    private let container: UIView = {
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
        label.textColor = .white
        label.font = R.Fonts.avenirBook(with: 14)
        label.text = ""
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        label.font = R.Fonts.avenirBook(with: 14)
        label.text = ""
        return label
    }()
    
    private let prodImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true
        //view.layer.cornerRadius = 16
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(container)
        addSubview(prodImage)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(countLabel)
        backgroundColor = .clear
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(title: String, quantity: Int, price: Int, orderTime: String) {
        self.titleLabel.text = "\(title)"
        prodImage.image = UIImage(named: "\(title)")
        countLabel.text = "\(quantity)"
        priceLabel.text = "\(price) ₽"
        countLabel.text = " x \(quantity)"
        
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            titleLabel.leadingAnchor.constraint(equalTo: prodImage.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: prodImage.centerYAnchor, constant: -8),
            titleLabel.widthAnchor.constraint(equalToConstant: bounds.width - 24),
            
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: countLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            priceLabel.widthAnchor.constraint(equalToConstant: 50),
            
            countLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            countLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            countLabel.widthAnchor.constraint(equalToConstant: 50),
            
            prodImage.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            prodImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            prodImage.heightAnchor.constraint(equalToConstant: bounds.height + 32),
            prodImage.widthAnchor.constraint(equalTo: container.heightAnchor),
            
            
        ])
    }
}

