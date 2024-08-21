//
//  CardInfoController.swift
//  FishShop
//
//  Created by Мурат Кудухов on 13.03.2024.
//

import UIKit

final class CardInfoController: UIViewController {
    
    private var infoSection = Stack(title: "", weight: "", size: "", temp: "")
    
    private let arrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "arrowLeft")!.withRenderingMode(.alwaysTemplate), for: .normal)
        button.layer.masksToBounds = true
        button.tintColor = .white
        return button
    }()
    
    private let prodImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        view.image = UIImage(named: "salmon")
        return view
    }()
    
    private let arrowView = RoundedView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.background
        //self.navigationItem.hidesBackButton = false
        navigationController?.navigationBar.barTintColor = .white
        view.addSubview(prodImage)
        view.addSubview(arrowView)
        arrowView.alpha = 0.5
        view.addSubview(arrowButton)
    
        buttonsAction()
    
        constraints()
    }
    
    init(title: String, image: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.title = title
        self.prodImage.image = UIImage(named: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonsAction() {
        arrowButton.addTarget(self, action: #selector(arrowButtonAction), for: .touchUpInside)
    }
    
    @objc
    func arrowButtonAction() {
        print("arrowCloseButton")
        navigationController?.popViewController(animated: true)
    }
    
    func constraints() {
        
        NSLayoutConstraint.activate([
            
            prodImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            prodImage.topAnchor.constraint(equalTo: view.topAnchor),
            prodImage.widthAnchor.constraint(equalToConstant: view.bounds.width - 24),
            prodImage.heightAnchor.constraint(equalToConstant: view.bounds.height/3.5),
            
            arrowButton.centerXAnchor.constraint(equalTo: arrowView.centerXAnchor),
            arrowButton.centerYAnchor.constraint(equalTo: arrowView.centerYAnchor),
            arrowButton.heightAnchor.constraint(equalToConstant: 18),
            arrowButton.widthAnchor.constraint(equalToConstant: 9),
            
            arrowView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            arrowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arrowView.heightAnchor.constraint(equalToConstant: 56),
            arrowView.widthAnchor.constraint(equalToConstant: 80),
        ])
        
        
    }
}


