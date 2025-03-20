//
//  LaunchScreenController.swift
//  FishShop
//
//  Created by Мурат Кудухов on 19.03.2025.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Установите фоновый цвет
        view.backgroundColor = .white

        // Добавьте изображение (логотип)
        let imageView = UIImageView(image: UIImage(named: "bgScreen"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        // Разместите логотип по центру
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
