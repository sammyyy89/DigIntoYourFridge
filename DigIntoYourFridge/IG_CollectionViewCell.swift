//
//  IG_CollectionViewCell.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/27/22.
//

import UIKit
import Kingfisher

class IG_CollectionViewCell: UICollectionViewCell {
    var ingredient: Ingredients! {
        didSet {
            lbIngredientName.text = ingredient.name
            
            guard let url = URL(string: "https://spoonacular.com/cdn/ingredients_100x100/\(ingredient.image)")
            else {
                return
            }
            imgIngredient.kf.setImage(with: url)
        }
    }
    
    @IBOutlet weak var imgIngredient: UIImageView!
    @IBOutlet weak var lbIngredientName: UILabel!
}
