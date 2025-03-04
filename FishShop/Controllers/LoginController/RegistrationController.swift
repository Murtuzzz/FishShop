//
//  RegisterController.swift
//  FishShop
//
//  Created by Мурат Кудухов on 18.04.2024.
//

import UIKit

class RegistrationController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Регистрация"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 36)
        return label
    }()
    
    private let loginTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 30
        textField.layer.borderWidth = 2
        textField.textColor = .white
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.attributedPlaceholder = NSAttributedString(
                    string: "Введите логин",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        return textField
    }()
    
    private let passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .white
        textField.layer.cornerRadius = 30
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(
                    string: "Введите пароль",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        return textField
    }()
    
    private let passwordRepeatTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .white
        textField.layer.cornerRadius = 30
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(
                    string: "Повторите пароль",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sing in", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.backgroundColor = .systemBlue
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.background
        view.addSubview(titleLabel)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(passwordRepeatTextField)
        view.addSubview(registerButton)
        
        registerButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        constraints()
    }

    func constraints() {
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.heightAnchor.constraint(equalToConstant: 64),
            
            loginTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            loginTextField.widthAnchor.constraint(equalToConstant: view.bounds.width - 64),
            loginTextField.heightAnchor.constraint(equalToConstant: 64),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalTo: loginTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 64),
            
            passwordRepeatTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordRepeatTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            passwordRepeatTextField.widthAnchor.constraint(equalTo: loginTextField.widthAnchor),
            passwordRepeatTextField.heightAnchor.constraint(equalToConstant: 64),
            
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: passwordRepeatTextField.bottomAnchor, constant: 20),
            registerButton.heightAnchor.constraint(equalToConstant: 64),
            registerButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
        ])
    }

    @objc func loginButtonTapped() {
        
        if let login = loginTextField.text {
            if loginTextField.text != "" {
                if passwordTextField.text == passwordRepeatTextField.text {
                    userData[login] = passwordTextField.text
                    dismiss(animated: true)
                } else {
                    passwordTextField.text = ""
                    passwordTextField.layer.borderColor = UIColor.red.cgColor
                    passwordTextField.layer.borderWidth = 1
                    passwordRepeatTextField.text = ""
                    passwordRepeatTextField.layer.borderColor = UIColor.red.cgColor
                    passwordRepeatTextField.layer.borderWidth = 1
                }
            }
        }
        // Переход к другому ViewController el.value == loginTextField.text
        
        
        
    }
}
