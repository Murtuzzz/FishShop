//
//  TapGesture.swift
//  FishShop
//
//  Created by Мурат Кудухов on 24.04.2024.
//

import UIKit

class GestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view is UITextField {
            // Не получать жесты от UITextField
            return false
        }
        return true
    }
}

