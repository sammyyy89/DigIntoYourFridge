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

struct Step: Decodable {
    var number: Int?
    var step: String?
}

struct Instructions: Decodable {
    var name: String?
    var steps: [Step]?
}
