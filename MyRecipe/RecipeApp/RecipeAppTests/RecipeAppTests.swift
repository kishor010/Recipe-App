//
//  RecipeAppTests.swift
//  RecipeApp
//
//  Created by Kishor Pahalwani on 18/02/20.
//  Copyright © 2020 fourtitude. All rights reserved.
//

import XCTest
@testable import RecipeApp

class RecipeAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testModels() {
        let modelRecipe = RecipeModel.init(id: nil, recipeName: nil, categoryId: nil, cookingSteps: nil, ingredients: nil, timeDuration: nil)
        
        let category = CategoryModel.init(id: nil, categoryName: "Value")
        
        XCTAssertEqual(modelRecipe.categoryId, category.id)
        XCTAssert(modelRecipe.categoryId == nil)
        XCTAssert(category.categoryName != modelRecipe.recipeName)
        XCTAssert(modelRecipe.timeDuration == nil, "true")
        XCTAssertNil(modelRecipe.id)
        XCTAssertNil(category.id, "true")
    }
    
    func testModelCategories() {
        let modelRecipe = RecipeModel.init(id: "11", recipeName: nil, categoryId: "1", cookingSteps: nil, ingredients: nil, timeDuration: nil)
        
        let category = CategoryModel.init(id: "1", categoryName: "Value")
        XCTAssertEqual(modelRecipe.categoryId, category.id)
        XCTAssert(modelRecipe.categoryId != nil)
        XCTAssert(category.categoryName != modelRecipe.recipeName)
        XCTAssert(modelRecipe.timeDuration == nil, "true")
        XCTAssertTrue(modelRecipe.id != nil)
        XCTAssertNotNil(category.id)
        XCTAssertNoThrow(modelRecipe)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
