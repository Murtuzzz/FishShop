//
//  ProfileController.swift
//  FishShop
//
//  Created by Мурат Кудухов on 08.03.2024.
//

import UIKit

struct ProfileData {
    let title: String
    let image: String
    let time: String
}

class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    private var profileData:[ProfileData] = []
    
    private let basketView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.barBg.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let orderHistoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.text = "История заказов"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.gillSans(with: 18)
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "door.right.hand.open"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Henry"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 32)
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = R.Colors.barBg
        //view.layer.cornerRadius = 25
        return view
    }()
    
    private let profileImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Fish")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .systemOrange
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerView)
        view.addSubview(profileImage)
        view.addSubview(nameLabel)
        view.addSubview(basketView)
        view.addSubview(logoutButton)
        view.addSubview(orderHistoryLabel)
        title = "Profile"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        logoutButton.addTarget(self, action: #selector(logOutButtonAction), for: .touchUpInside)
        createTable()
        view.backgroundColor = R.Colors.background
    }
    
    init(login: String, id: String) {
        super.init(nibName: nil, bundle: nil)
        nameLabel.text = login
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func logOutButtonAction() {
        if let tabBarController = self.tabBarController as? TabBarController {
            User.isAuthorized = true
            tabBarController.logOut()
            tabBarController.switchTo(tab: .profile)
        }
    }
    
    func createTable() {
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = R.Colors.background
        self.tableView.isScrollEnabled = true
        self.tableView.backgroundColor = R.Colors.barBg
        self.tableView.layer.cornerRadius = 20
        self.tableView.register(ProfileTableCell.self, forCellReuseIdentifier: ProfileTableCell.id)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -16),
            
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height / 2.5),
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -48),
            
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -16),
            profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: view.bounds.width/1.5),
            
            basketView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            basketView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -16),
            basketView.heightAnchor.constraint(equalToConstant: 56),
            basketView.widthAnchor.constraint(equalToConstant: 80),
            
            logoutButton.trailingAnchor.constraint(equalTo: basketView.trailingAnchor, constant: 8),
            logoutButton.centerYAnchor.constraint(equalTo: basketView.centerYAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 80),
            logoutButton.widthAnchor.constraint(equalTo: logoutButton.heightAnchor),
            
            orderHistoryLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -8),
            orderHistoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            orderHistoryLabel.heightAnchor.constraint(equalToConstant: 24),
            orderHistoryLabel.widthAnchor.constraint(equalToConstant: view.bounds.width)
        ])
        
        for i in stride(from: UserSettings.ordersHistory.count-1, through: 0, by: -1) {
            profileData.append(.init(title: UserSettings.ordersHistory[i][0][0].title, image: UserSettings.ordersHistory[i][0][0].title, time: UserSettings.ordersHistory[i][0][0].orderTime))
        }
        
        tableView.reloadData()
//        profileData = [.init(title: "04.08.24", image: "Grilled fish"),
//                       .init(title: "03.08.24", image: "Grilled fish"),
//                       .init(title: "02.08.24", image: "Grilled fish"),
//                       .init(title: "01.08.24", image: "Grilled fish")]
    }
}


// MARK: - UITableView
extension ProfileController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserSettings.ordersHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableCell.id, for: indexPath) as! ProfileTableCell
        
        print("profileData = \(profileData)")
        print("index = \(indexPath.row)")
        let cellData = profileData[indexPath.row]
        
        cell.config(title: cellData.time, image: cellData.image)
        cell.selectionStyle = .gray
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}
