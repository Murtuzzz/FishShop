//
//  Ext.swift
//  FishShop
//
//  Created by Мурат Кудухов on 08.03.2024.
//

import UIKit

final class Stack: UIView {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 10
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
    }
    
    init(title: String, weight: String, size: String, temp: String) {
        super.init(frame: .zero)
        
        let weightInfo = InfoBlock(title: "weight", info: weight)
        let sizeInfo = InfoBlock(title: "size", info: size)
        let tempInfo = InfoBlock(title: "temp", info: temp)
        
        stackView.addArrangedSubview(weightInfo)
        stackView.addArrangedSubview(sizeInfo)
        stackView.addArrangedSubview(tempInfo)
        
        addSubview(stackView)

        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
