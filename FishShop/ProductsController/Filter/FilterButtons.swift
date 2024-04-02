//
//  FilterButtons.swift
//  FishShop
//
//  Created by Мурат Кудухов on 10.03.2024.
//

import UIKit

final class FilterButtons: UIView {
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20
        return view
        
    }()
    
    private let buttonAll = ProdButton(title: "All", initialSelection: true)
    private let buttonSalmon = ProdButton(title: "Salmon")
    private let buttonFrozen = ProdButton(title: "Frozen")
    
    
    var onFilterChange: ((ProdFilter) -> ())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.addArrangedSubview(buttonAll)
        stackView.addArrangedSubview(buttonFrozen)
        stackView.addArrangedSubview(buttonSalmon)
        
        addSubview(stackView)
        settings()
        constraints()
        
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    func settings() {
        buttonAll.onTap = {
            self.buttonFrozen.setSelected(false)
            self.buttonSalmon.setSelected(false)
            self.onFilterChange?(.all)
        }
        buttonSalmon.onTap = {
            self.buttonAll.setSelected(false)
            self.buttonFrozen.setSelected(false)
            self.onFilterChange?(.salmon)
        }
        buttonFrozen.onTap = {
            self.buttonSalmon.setSelected(false)
            self.buttonAll.setSelected(false)
            self.onFilterChange?(.frozen)
        }
    }
}

