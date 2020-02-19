//
//  DBService.swift
//  RecipeApp
//
//  Created by Kishor Pahalwani on 18/02/20.
//  Copyright © 2020 fourtitude. All rights reserved.
//

import Foundation
import CoreData

class DBService {
    
    static let sharedInstance : DBService = {
        let sharedInstance = DBService()
        return sharedInstance
    }()
    
    //MARK:- Save Categories into DB
    func saveUpdateCategory(model: CategoryModel) {
        
        var entityCategory: CategoryDB!
        
        if let category = categoryExist(id: model.id) {
            entityCategory = category
        }
        
        else {
            entityCategory = CategoryDB.init(context: AppDelegate.getContext())
        }
        
        entityCategory.categoryId = model.id
        entityCategory.categoryName = model.categoryName
        self.saveContext()
    }
    
    fileprivate func categoryExist(id: String?) -> CategoryDB? {
        var category: CategoryDB?
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBConstants.categoryDB)
        fetchRequest.predicate = NSPredicate(format: "categoryId == %@ ", id ?? "")
        do {
            let arrModels = try AppDelegate.getContext().fetch(fetchRequest) as! [CategoryDB]
            
            if arrModels.count > 0 {
                category = arrModels[0]
            }
        }
        catch let error {
            //Handle Error
            print(error as AnyObject)
        }
        
        return category
    }
    
    func fetchAllCategories() -> [CategoryModel] {
        
        var categories: [CategoryDB] = []
        var arrModelCategories: [CategoryModel] = []
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBConstants.categoryDB)
        do {
            let arrModels = try AppDelegate.getContext().fetch(fetchRequest) as! [CategoryDB]
            categories = arrModels
        }
        catch let error {
            //Handle Error
            print(error as AnyObject)
        }
        
        for category in categories {
            let model = CategoryModel.init(id: category.categoryId, categoryName: category.categoryName)
            arrModelCategories.append(model)
        }
        
        return arrModelCategories
    }
    
    func fetchCategoryBy(id: String?) -> [CategoryModel] {
        
        var categories: [CategoryDB] = []
        var arrModelCategories: [CategoryModel] = []
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBConstants.categoryDB)
        
        fetchRequest.predicate = NSPredicate(format: "categoryId == %@ ", id ?? "")
        
        do {
            let arrModels = try AppDelegate.getContext().fetch(fetchRequest) as! [CategoryDB]
            categories = arrModels
        }
        catch let error {
            //Handle Error
            print(error as AnyObject)
        }
        
        for category in categories {
            let model = CategoryModel.init(id: category.categoryId, categoryName: category.categoryName)
            arrModelCategories.append(model)
        }
        
        return arrModelCategories
    }
    
    //MARK:- Save Context
    func saveContext() {
        do {
            try AppDelegate.getContext().save()
        }
            
        catch let contextError {
            //Error
            print(contextError as AnyObject)
        }
    }
}

//MARK:- Recipe
extension DBService {
    
    func fetchAllRecipes() -> [RecipeModel] {
        
        var recipes: [RecipeDB] = []
        var arrModelRecipes: [RecipeModel] = []
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBConstants.recipeDB)
        
        do {
            let arrModels = try AppDelegate.getContext().fetch(fetchRequest) as! [RecipeDB]
            recipes = arrModels
        }
            
        catch let error {
            //Handle Error
            print(error as AnyObject)
        }
        
        for recipe in recipes {
            let model = RecipeModel.init(id: recipe.recipeId, recipeName: recipe.recipeName, categoryId: recipe.categoryId, cookingSteps: recipe.cookingSteps, ingredients: recipe.ingredients, timeDuration: recipe.timeDuration)
            arrModelRecipes.append(model)
        }
        
        return arrModelRecipes
    }
    
    func fetchAllRecipesWithCategory(categoryId: String?) -> [RecipeModel] {
        
        var recipes: [RecipeDB] = []
        var arrModelRecipes: [RecipeModel] = []
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBConstants.recipeDB)
        
        fetchRequest.predicate = NSPredicate(format: "categoryId == %@ ", categoryId ?? "")
        
        do {
            let arrModels = try AppDelegate.getContext().fetch(fetchRequest) as! [RecipeDB]
            recipes = arrModels
        }
            
        catch let error {
            //Handle Error
            print(error as AnyObject)
        }
        
        for recipe in recipes {
            let model = RecipeModel.init(id: recipe.recipeId, recipeName: recipe.recipeName, categoryId: recipe.categoryId, cookingSteps: recipe.cookingSteps, ingredients: recipe.ingredients, timeDuration: recipe.timeDuration)
            arrModelRecipes.append(model)
        }
        
        return arrModelRecipes
    }
    
    //MARK:- Save Recipe into DB
    func saveUpdateRecipe(model: RecipeModel?) {
        
        var entityRecipe: RecipeDB!
        
        if let recipe = RecipeExist(id: model?.id) {
            entityRecipe = recipe
            entityRecipe.recipeId = model?.id
        }
        
        else {
            entityRecipe = RecipeDB.init(context: AppDelegate.getContext())
        }
        
        entityRecipe.categoryId = model?.categoryId
        entityRecipe.recipeName = model?.recipeName
        entityRecipe.cookingSteps = model?.cookingSteps
        entityRecipe.ingredients = model?.ingredients
        entityRecipe.timeDuration = model?.timeDuration
        entityRecipe.recipeId = model?.id
        self.saveContext()
    }
    
    fileprivate func RecipeExist(id: String?) -> RecipeDB? {
        
        var recipe: RecipeDB?
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBConstants.recipeDB)
        fetchRequest.predicate = NSPredicate(format: "recipeId == %@ ", id ?? "")
        do {
            let arrModels = try AppDelegate.getContext().fetch(fetchRequest) as! [RecipeDB]
            
            if arrModels.count > 0 {
                recipe = arrModels[0]
            }
        }
        catch let error {
            //Handle Error
            print(error as AnyObject)
        }
        
        return recipe
    }
}


//MARK:- Recipe Delete from Core Data
extension DBService {
    func deleteRecipe(id: String?, categoryId: String?) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBConstants.recipeDB)
        fetchRequest.predicate = NSPredicate(format: "recipeId == %@ AND categoryId == %@ ", id ?? "", categoryId ?? "")
        do {
            let arrModels = try AppDelegate.getContext().fetch(fetchRequest) as! [RecipeDB]
            for obj in arrModels {
                AppDelegate.getContext().delete(obj)
            }
            self.saveContext()
        }
        catch let error {
            //Handle Error
            print(error as AnyObject)
        }
    }
}

