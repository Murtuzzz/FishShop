//
//  UserSettings.swift
//  FishShop
//
//  Created by Мурат Кудухов on 26.03.2024.
//

import Foundation

struct BasketInfo: Codable {
    let title: String
    let price: Double
    var quantity: Int
    let id: Int
    var inBasket: Bool
}

final class UserSettings {
    
    private enum SettingsKeys: String {
        case basketInfo
        case basketProdQuant
        case address
    }
    
    static var basketInfo: [[BasketInfo]]! {
        get {
            guard let data = UserDefaults.standard.data(forKey: SettingsKeys.basketInfo.rawValue) else { return nil }
            let decoder = JSONDecoder()
            return try? decoder.decode([[BasketInfo]].self, from: data)
        } set {
            let encoder = JSONEncoder()
            let encoded = try? encoder.encode(newValue)
            UserDefaults.standard.set(encoded, forKey: SettingsKeys.basketInfo.rawValue)
        }
    }
    
    static var basketProdQuant: Int! {
        get {
            return UserDefaults.standard.integer(forKey: SettingsKeys.basketProdQuant.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.basketProdQuant.rawValue
            if let today = newValue {
                print("value: \(today) was added to key \(key)")
                defaults.set(today, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var address: String! {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.address.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.address.rawValue
            if let today = newValue {
                print("value: \(today) was added to key \(key)")
                defaults.set(today, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
