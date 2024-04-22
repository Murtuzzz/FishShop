//
//  PricesView.swift
//  FishShop
//
//  Created by Мурат Кудухов on 15.04.2024.
//

import UIKit

final class PricesView: UIView {
    
    private let stackViewFirst: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.backgroundColor = R.Colors.background
        return view
    }()
    
    private let stackViewSecond: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.backgroundColor = R.Colors.background
        return view
    }()
    
    private let stackViewThird: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.backgroundColor = R.Colors.background
        return view
    }()
    
    private let stackViewV: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        view.backgroundColor = R.Colors.barBg.withAlphaComponent(0.5)
        view.spacing = 1
        return view
    }()
    
    private let sumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 14)
        label.textColor = .white
        label.text = "Продуктов на сумму"
        return label
    }()
    
    private let sumCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 14)
        label.textColor = .white
        label.text = "7456 р"
        return label
    }()
    
    private let delivLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 14)
        label.textColor = .white
        label.text = "Доставка"
        return label
    }()
    
    private let delivCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 14)
        label.textColor = .white
        label.text = "299 р"
        return label
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 20)
        label.text = "Итого"
        label.textColor = .white
        return label
    }()
    
    private let totalCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 20)
        label.text = "7755 р"
        label.textColor = .white
        return label
    }()
    
    init(totalSum: Double) {
        super.init(frame: .zero)
        sumCountLabel.text = "\(totalSum) р"
        totalCountLabel.text = "\(totalSum + 299.0) р"
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        stackViewFirst.addArrangedSubview(sumLabel)
        stackViewFirst.addArrangedSubview(sumCountLabel)
        
        stackViewSecond.addArrangedSubview(delivLabel)
        stackViewSecond.addArrangedSubview(delivCountLabel)
        
        stackViewThird.addArrangedSubview(totalLabel)
        stackViewThird.addArrangedSubview(totalCountLabel)
        
        stackViewV.addArrangedSubview(stackViewFirst)
        stackViewV.addArrangedSubview(stackViewSecond)
        stackViewV.addArrangedSubview(stackViewThird)
        
        addSubview(stackViewV)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            stackViewV.topAnchor.constraint(equalTo: topAnchor),
            stackViewV.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackViewV.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackViewV.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            totalCountLabel.trailingAnchor.constraint(equalTo: stackViewV.trailingAnchor),
            totalCountLabel.leadingAnchor.constraint(equalTo: totalLabel.trailingAnchor),
            
            sumCountLabel.trailingAnchor.constraint(equalTo: stackViewV.trailingAnchor),
            sumCountLabel.leadingAnchor.constraint(equalTo: sumLabel.trailingAnchor),
            
            delivCountLabel.trailingAnchor.constraint(equalTo: stackViewV.trailingAnchor),
            delivCountLabel.leadingAnchor.constraint(equalTo: delivLabel.trailingAnchor),
            
        
        ])
    }
}
