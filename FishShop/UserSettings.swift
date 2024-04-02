//
//  UserSettings.swift
//  FishShop
//
//  Created by Мурат Кудухов on 26.03.2024.
//

import Foundation

final class UserSettings {
    
    private enum SettingsKeys: String {
        case basket
        
    }
    
    static var basket: [String:Any]! {
        get {
            return UserDefaults.standard.dictionary(forKey: SettingsKeys.basket.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.basket.rawValue
            if let basket = newValue {
                //print("value: \(basket) was added to key \(key)")
                print(basket)
                defaults.set(basket, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
