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
    let catId: Int
    let inStock: Bool
    let prodCount: Int
    
}

struct StoreData: Codable {
    let title: String
    let price: String
    var quantity: Int
    let inStock: Bool
    let id: Int
    let categoryId: Int
}

struct Adress: Codable {
    var adress: String
    var latitude: Double
    var longitude: Double
}

final class UserSettings {
    
    private enum SettingsKeys: String {
        case basketInfo
        case basketProdQuant
        case address
        case orderPaid
        case orderInfo
        case adress
        case activeOrder
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
    
    static var adress: [[Adress]]! {
        get {
            guard let data = UserDefaults.standard.data(forKey: SettingsKeys.adress.rawValue) else { return nil }
            let decoder = JSONDecoder()
            return try? decoder.decode([[Adress]].self, from: data)
        } set {
            let encoder = JSONEncoder()
            let encoded = try? encoder.encode(newValue)
            UserDefaults.standard.set(encoded, forKey: SettingsKeys.adress.rawValue)
        }
    }
    
    static var storeData: [[StoreData]]! {
        get {
            guard let data = UserDefaults.standard.data(forKey: SettingsKeys.basketInfo.rawValue) else { return nil }
            let decoder = JSONDecoder()
            return try? decoder.decode([[StoreData]].self, from: data)
        } set {
            let encoder = JSONEncoder()
            let encoded = try? encoder.encode(newValue)
            UserDefaults.standard.set(encoded, forKey: SettingsKeys.basketInfo.rawValue)
        }
    }
    
    static var orderInfo: [[BasketInfo]]! {
        get {
            guard let data = UserDefaults.standard.data(forKey: SettingsKeys.orderInfo.rawValue) else { return nil }
            let decoder = JSONDecoder()
            return try? decoder.decode([[BasketInfo]].self, from: data)
        } set {
            let encoder = JSONEncoder()
            let encoded = try? encoder.encode(newValue)
            UserDefaults.standard.set(encoded, forKey: SettingsKeys.orderInfo.rawValue)
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
    
    static var orderPaid: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.orderPaid.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.orderPaid.rawValue
            if let today = newValue {
                print("value: \(today) was added to key \(key)")
                defaults.set(today, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var activeOrder: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.activeOrder.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.activeOrder.rawValue
            if let today = newValue {
                print("value: \(today) was added to key \(key)")
                defaults.set(today, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    
}