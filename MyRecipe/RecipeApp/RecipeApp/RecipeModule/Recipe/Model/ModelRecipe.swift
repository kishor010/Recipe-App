//
//  ModelRecipe.swift
//  RecipeApp
//
//  Created by Kishor Pahalwani on 18/02/20.
//  Copyright © 2020 fourtitude. All rights reserved.
//

import Foundation

struct RecipeModel: Codable {
    
    var categoryId: String?
    var cookingSteps: String?
    var ingredients: String?
    var recipeName: String?
    var timeDuration: String?
    var id: String?
    
    enum CodingKeys: String, CodingKey {
        case categoryId
        case cookingSteps
        case ingredients
        case recipeName
        case timeDuration
        case id
    }
    
    init(id: String?, recipeName: String?, categoryId: String?, cookingSteps: String?, ingredients: String?, timeDuration: String?) {
        self.categoryId = categoryId
        self.cookingSteps = cookingSteps
        self.ingredients = ingredients
        self.recipeName = recipeName
        self.timeDuration = timeDuration
        self.id = id
    }
    
    //helps to Encode the object
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(categoryId, forKey: .categoryId)
        try container.encode(cookingSteps, forKey: .cookingSteps)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(recipeName, forKey: .recipeName)
        try container.encode(timeDuration, forKey: .timeDuration)
        try container.encode(id, forKey: .id)
    }
    
    //helps to Decode the object
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        categoryId = try container.decode(String.self, forKey: .categoryId)
        cookingSteps = try container.decode(String.self, forKey: .cookingSteps)
        ingredients = try container.decode(String.self, forKey: .ingredients)
        recipeName = try container.decode(String.self, forKey: .recipeName)
        timeDuration = try container.decode(String.self, forKey: .timeDuration)
        id = try container.decode(String.self, forKey: .id)
    }
}
