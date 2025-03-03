//
//  RegistrationContr.swift
//  FishShop
//
//  Created by Мурат Кудухов on 18.04.2024.
//

import UIKit

final class LoginController: UIViewController {
    
    private let accCreateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Еще нет аккаунта?"
        label.textColor = .white
        label.font = R.Fonts.avenirBook(with: 16)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Войдите, чтобы продолжить"
        label.textColor = .white
        label.font = R.Fonts.gillSans(with: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let logoImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "Fish")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let loginTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 15
        textField.layer.borderWidth = 1
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
        textField.layer.cornerRadius = 15
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(
                    string: "Введите пароль",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sing in", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.backgroundColor = .systemBlue
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Создать", for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
        

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.background
        title = "Login"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(logoImage)
        view.addSubview(accCreateLabel)
        view.addSubview(titleLabel)
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(regButtonTapped), for: .touchUpInside)
        
        constraints()
    }

    func constraints() {
        
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.heightAnchor.constraint(equalToConstant: view.bounds.width - 136),
            logoImage.widthAnchor.constraint(equalTo: logoImage.heightAnchor),
            
            loginTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            loginTextField.widthAnchor.constraint(equalToConstant: view.bounds.width - 64),
            loginTextField.heightAnchor.constraint(equalToConstant: 64),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalTo: loginTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 64),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.heightAnchor.constraint(equalToConstant: 64),
            loginButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
            
            registerButton.leadingAnchor.constraint(equalTo: accCreateLabel.trailingAnchor, constant: 3),
            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            registerButton.heightAnchor.constraint(equalToConstant: 16),
            
            accCreateLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            accCreateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -32),
            accCreateLabel.heightAnchor.constraint(equalTo: registerButton.heightAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 16),
            
        ])
    }

    @objc func loginButtonTapped() {
        // Переход к другому ViewController el.value == loginTextField.text
        
        for el in userData {
            if el.key == loginTextField.text && el.value == passwordTextField.text {
                guard let login = loginTextField.text else {return}
                guard let id = passwordTextField.text else {return}
                //self.navigationController?.pushViewController(profileController, animated: true)
                if let tabBarController = self.tabBarController as? TabBarController {
                    User.isAuthorized = true
                    tabBarController.updateProfileTab(login: login, id: id)
                    tabBarController.switchTo(tab: .profile)
                }
            } else {
                                                                 
            }
        }
    }
    
    @objc func regButtonTapped() {
        let profileController = RegistrationController()
        present(profileController, animated: true)
    }
}
