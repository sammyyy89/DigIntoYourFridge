//
//  post.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/14/22.
//

import Foundation

struct Recipes: Codable {
    var id: Int!
    var title: String
    var image: String
    var imageType: String!
    var usedIngredientCount: Int
    var missedIngredientCount: Int
    var missedIngredients: [Missed]
    var usedIngredients: [Used]
    // var likes: Int!
}

struct RegularRecipes: Codable {
    var id: Int
    var title: String
    var image: String
}

struct Missed: Codable {
    var id: Int
    var name: String
}

struct Used: Codable {
    var id: Int
    var name: String
}

struct Ingredients: Codable {
    var name: String
    var image: String
}

struct Instructions: Codable {
    var name: String?
    var steps: [Step]
}

struct Step: Codable {
    var number: Int
    var step: String
    var ingredients: [IngredientsForInst]
    var equipment: [Equipments]
}

struct IngredientsForInst: Codable {
    var id: Int
    var name: String
    var localizedName: String
}

struct Equipments: Codable {
    var id: Int
    var name: String
    var localizedName: String
}
