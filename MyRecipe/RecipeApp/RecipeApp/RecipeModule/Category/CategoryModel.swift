//
//  CategoryModel.swift
//  RecipeApp
//
//  Created by Kishor Pahalwani on 18/02/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import Foundation

struct CategoryModel: Codable {
    
    var id: String?
    var categoryName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryName
    }
    
    init(id: String?, categoryName: String?) {
        self.id = id
        self.categoryName = categoryName
    }
    
    //helps to Encode the object
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(categoryName, forKey: .categoryName)
    }
    
    //helps to Decode the object
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        categoryName = try container.decode(String.self, forKey: .categoryName)
    }
}
