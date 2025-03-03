//
//  ProfileOrderCell.swift
//  FishShop
//
//  Created by Мурат Кудухов on 04.09.2024.
//


import UIKit

final class ProfileOrderCell: UITableViewCell {
    
    static var id = "ProfileOrderCell"
    
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
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(mainView)
        addSubview(prodImage)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(countLabel)
        contentView.addSubview(addButton)
        contentView.addSubview(delButton)
        backgroundColor = .clear
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(title: String, quantity: Int, price: Int) {
        self.titleLabel.text = "\(title)"
        prodImage.image = UIImage(named: "\(title)")
        countLabel.text = "\(quantity)"
        priceLabel.text = "\(price) ₽"
    }
    
    func buttonsActions() {
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        delButton.addTarget(self, action: #selector(delButtonAction), for: .touchUpInside)
    }
    
    @objc
    func addButtonAction() {
    }
    
    @objc
    func delButtonAction() {
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
            countLabel.widthAnchor.constraint(equalToConstant: 8),
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
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}

