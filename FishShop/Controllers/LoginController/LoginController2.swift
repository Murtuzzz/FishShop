//
//  LoginController2.swift
//  FishShop
//
//  Created by Мурат Кудухов on 21.03.2025.
//


import UIKit
import FirebaseAuth

class LoginController2: UIViewController {
    
    // Поле ввода для номера телефона
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите номер телефона"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        return textField
    }()
    
    // Кнопка для отправки кода
    private let sendCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отправить код", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(sendCodeTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Добавляем элементы на экран
        view.addSubview(phoneNumberTextField)
        view.addSubview(sendCodeButton)
        
        // Устанавливаем ограничения для auto layout
        NSLayoutConstraint.activate([
            // Поле ввода
            phoneNumberTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneNumberTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            phoneNumberTextField.widthAnchor.constraint(equalToConstant: 250),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Кнопка
            sendCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendCodeButton.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 20),
            sendCodeButton.widthAnchor.constraint(equalToConstant: 150),
            sendCodeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // Обработчик нажатия кнопки
    @objc private func sendCodeTapped() {
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            print("Введите номер телефона")
            return
        }
        
        guard phoneNumber.starts(with: "+") else {
            print("Номер телефона должен быть в формате E.164, например, +79991234567")
            return
        }
        
        print("Попытка отправить код для номера: \(phoneNumber)")
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print("Ошибка при отправке кода: \(error.localizedDescription)")
                return
            }
            print("Verification ID получен: \(verificationID ?? "nil")")
           
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            DispatchQueue.main.async {
                //self.performSegue(withIdentifier: "toVerificationCode", sender: nil)
            }
        }
        present(VerificationCodeViewController(), animated: true)
    }
}

