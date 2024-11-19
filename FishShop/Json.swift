//
//  Json.swift
//  FishShop
//
//  Created by Мурат Кудухов on 04.05.2024.
//

import Foundation

// Определение структуры для представления продукта.
struct Product: Codable {
    let id: Int
    let name: String
    let description: String?
    let price:  String
    let inStock: Bool
    let productCount: Double
    let category: Int
    
    // Ключи для кодирования и декодирования соответствуют ключам JSON, где нам нужно изменить стиль.
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case price
        case inStock = "in_stock"
        case productCount = "product_count"
        case category
    }
}


class Json {
    
    static var shared = Json()
    // Пример JSON-строки, которую вы хотите разобрать.
    let jsonString = """
[
    {"id":1,"name":"Tasty salmon","description":"По то своему это frozen, тупица?","price":"500.00","in_stock":true,"product_count":100.0,"category":1},
    {"id":2,"name":"Grilled fish","description":"Бекещеке","price":"199.00","in_stock":true,"product_count":23.0,"category":1},
    {"id":2,"name":"Tasty salmon","description":"fdsd","price":"199.00","in_stock":true,"product_count":23.0,"category":1}
]
"""
    
    // Функция для разбора JSON и преобразования его в массив продуктов.
    func parseProducts(from jsonString: String) -> [Product]? {
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        
        let decoder = JSONDecoder()
        do {
            let products = try decoder.decode([Product].self, from: jsonData)
            return products
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
}
