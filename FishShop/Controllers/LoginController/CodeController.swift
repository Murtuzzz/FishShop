//
//  CodeController.swift
//  FishShop
//
//  Created by Мурат Кудухов on 21.03.2025.
//

import UIKit
import FirebaseAuth

class VerificationCodeViewController: UIViewController {
    
    // Поле ввода для кода подтверждения
    private let verificationCodeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите код подтверждения"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    // Кнопка для подтверждения
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Подтвердить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Добавляем элементы на экран
        view.addSubview(verificationCodeTextField)
        view.addSubview(confirmButton)
        
        // Устанавливаем ограничения для auto layout
        NSLayoutConstraint.activate([
            // Поле ввода
            verificationCodeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verificationCodeTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            verificationCodeTextField.widthAnchor.constraint(equalToConstant: 250),
            verificationCodeTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Кнопка
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: verificationCodeTextField.bottomAnchor, constant: 20),
            confirmButton.widthAnchor.constraint(equalToConstant: 150),
            confirmButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // Обработчик нажатия кнопки
    @objc private func confirmTapped() {
        guard let verificationCode = verificationCodeTextField.text, !verificationCode.isEmpty else {
                print("Введите код подтверждения")
                return
            }
            guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
                print("Verification ID не найден")
                return
            }
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
                verificationCode: verificationCode
            )
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Ошибка входа: \(error.localizedDescription)")
                    return
                }
                // Вход успешен
                print("Пользователь вошел: \(authResult?.user.uid ?? "ID не найден")")
                // Переход к основному экрану
                
            }
        dismiss(animated: true)
    }
}
