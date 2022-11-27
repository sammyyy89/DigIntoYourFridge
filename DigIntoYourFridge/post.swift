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
//    var missedIngredients: [String]!
//    var usedIngredients: [String]!
//    var unusedIngredients: [String]!
    var likes: Int!
}

struct Ingredients: Codable {
    var name: String!
    var image: String!
}
