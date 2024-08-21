//
//  ButtonFilter.swift
//  FishShop
//
//  Created by Мурат Кудухов on 10.03.2024.
//

import UIKit


final class ProdButton: UIView {
    private var isSelected = false
    
    
    var onTap: (() -> ())?
    
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = R.Fonts.avenirBook(with: 24)
        
        return label
    }()
    
    let buttonBody: UIView = {
        let view = UIView()
        //view.backgroundColor = R.Colors.active
        //view.layer.borderWidth = 1
        view.layer.cornerRadius = 21
        
        return view
    }()
    
    private let tapButton: UIButton = {
        let view = UIButton()
        return view
    }()
    
    
    init(title: String, initialSelection: Bool = false) {
        self.isSelected = initialSelection
        super.init(frame: .zero)
        
        addSubview(buttonBody)
        addSubview(label)
        addSubview(tapButton)
        
        label.text = title
        tapButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        updateState()
        
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setSelected(_ selected: Bool) {
        isSelected = selected
        updateState()
    }
    
    
    private func constraints() {
        buttonBody.translatesAutoresizingMaskIntoConstraints = false
        tapButton.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            buttonBody.topAnchor.constraint(equalTo: topAnchor),
            buttonBody.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonBody.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonBody.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            tapButton.topAnchor.constraint(equalTo: topAnchor),
            tapButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            tapButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            tapButton.trailingAnchor.constraint(equalTo: trailingAnchor)

        ])
    }
    
    
    private func updateState() {
        //buttonBody.backgroundColor = isSelected ? R.Colors.active : R.Colors.bar
        label.textColor = .gray
    }
    
    
    @objc
    private func buttonTapped() {
        isSelected = true
        updateState()
        label.textColor = .white
        onTap?()
    }
}
