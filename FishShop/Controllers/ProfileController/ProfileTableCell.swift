//
//  ProfileTableCell.swift
//  FishShop
//
//  Created by Мурат Кудухов on 22.04.2024.
//

import UIKit

final class ProfileTableCell: UITableViewCell {
     
    static var id = "ProfileTableCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Orders history"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.gillSans(with: 18)
        return label
    }()
    
    private let cellImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "cart")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let arrowImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        return view
    }()
    
    let bgImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.background
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(bgImageView)
        addSubview(arrowImageView)
        addSubview(titleLabel)
        addSubview(cellImageView)
        
        backgroundColor = .clear
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(title: String, image: String) {
        titleLabel.text = title
        cellImageView.image = UIImage(systemName: image)
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.heightAnchor.constraint(equalToConstant: 14),
            arrowImageView.widthAnchor.constraint(equalToConstant: 14),
            
            titleLabel.leadingAnchor.constraint(equalTo: bgImageView.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: bgImageView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 16),
            titleLabel.widthAnchor.constraint(equalToConstant: bounds.width),
           
            cellImageView.centerXAnchor.constraint(equalTo: bgImageView.centerXAnchor),
            cellImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cellImageView.heightAnchor.constraint(equalToConstant: bounds.height - 18),
            cellImageView.widthAnchor.constraint(equalTo: cellImageView.heightAnchor),
            
            bgImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bgImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bgImageView.heightAnchor.constraint(equalToConstant: bounds.height + 32),
            bgImageView.widthAnchor.constraint(equalToConstant: bounds.height + 32),
        
        ])
    }
    
}
