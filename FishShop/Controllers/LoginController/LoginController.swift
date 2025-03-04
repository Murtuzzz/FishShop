import UIKit

final class LoginController: UIViewController {
    
    // Create ScrollView
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        scroll.backgroundColor = R.Colors.background
        return scroll
    }()
    
    // Create contentView to hold all subviews
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        button.setTitle("Войти", for: .normal)
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
        navigationController?.navigationBar.barTintColor = R.Colors.background

        // Add scrollView and contentView hierarchy
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add all subviews to contentView instead of view
        contentView.addSubview(loginTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(loginButton)
        view.addSubview(registerButton)
        contentView.addSubview(logoImage)
        view.addSubview(accCreateLabel)
        contentView.addSubview(titleLabel)
        scrollView.isScrollEnabled = false
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(regButtonTapped), for: .touchUpInside)
        setupTapGesture()
        setupConstraints()
        
        // Add keyboard observers
        setupKeyboardObservers()
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
        view.endEditing(true)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1000),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Your existing constraints with updated parents
            logoImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            logoImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImage.heightAnchor.constraint(equalToConstant: view.bounds.width - 136),
            logoImage.widthAnchor.constraint(equalTo: logoImage.heightAnchor),
            
            loginTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loginTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            loginTextField.widthAnchor.constraint(equalToConstant: view.bounds.width - 64),
            loginTextField.heightAnchor.constraint(equalToConstant: 64),
            
            passwordTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalTo: loginTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 64),
            
            loginButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.heightAnchor.constraint(equalToConstant: 64),
            loginButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
            
            registerButton.leadingAnchor.constraint(equalTo: accCreateLabel.trailingAnchor, constant: 3),
            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            registerButton.heightAnchor.constraint(equalToConstant: 16),
            
            accCreateLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            accCreateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -32),
            accCreateLabel.heightAnchor.constraint(equalTo: registerButton.heightAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 16),
        ])
    }
    
    // Keyboard handling
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillShow),
                                             name: UIResponder.keyboardWillShowNotification,
                                             object: nil)
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillHide),
                                             name: UIResponder.keyboardWillHideNotification,
                                             object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        logoImage.alpha = 0
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let targetOffset = CGPoint(x: 0, y: keyboardHeight/2) 
            scrollView.setContentOffset(targetOffset, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        logoImage.alpha = 1
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let targetOffset = CGPoint(x: 0, y: 0)
            scrollView.setContentOffset(targetOffset, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
