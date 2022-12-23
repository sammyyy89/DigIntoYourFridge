//
//  post.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/14/22.
//

import Foundation

struct Recipes: Decodable {
    var id: Int!
    var title: String
    var image: String
    var imageType: String!
    var usedIngredientCount: Int
    var missedIngredientCount: Int
    var likes: Int!
}

struct Ingredients: Decodable {
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
    var ingredients: [Ingredient]
    var equipment: [Equipments]
}

struct Ingredient: Codable {
    var id: Int
    var name: String
    var localizedName: String
}

struct Equipments: Codable {
    var id: Int
    var name: String
    var localizedName: String
}
