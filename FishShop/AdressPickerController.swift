//
//  AdressPickerController.swift
//  FishShop
//
//  Created by Мурат Кудухов on 22.04.2024.
//

import UIKit

protocol AddressPickerDelegate: AnyObject {
    func addressDidPick(_ address: String)
}

class AddressPickerViewController: UIViewController {
    weak var delegate: AddressPickerDelegate?
    var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        // Создайте интерфейс с TextField и кнопкой OK
        textField = UITextField(frame: CGRect(x: 20, y: 100, width: 280, height: 40))
        textField.borderStyle = .roundedRect
        view.addSubview(textField)
        
        let okButton = UIButton(frame: CGRect(x: 20, y: 150, width: 280, height: 50))
        okButton.setTitle("OK", for: .normal)
        okButton.backgroundColor = .blue
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        view.addSubview(okButton)
    }

    @objc func okButtonTapped() {
        delegate?.addressDidPick(textField.text ?? "")
        dismiss(animated: true, completion: nil)
    }
}
