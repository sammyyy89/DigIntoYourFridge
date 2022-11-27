//
//  CollectionViewCell.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/26/22.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    var recipe: Recipes! {
        didSet {
            lbDishName.text = recipe.title
            
            if recipe.usedIngredientCount > 1 {
                lbNumofUsed.text = "\(String(recipe.usedIngredientCount)) ingredients used"
            } else {
                lbNumofUsed.text = "\(String(recipe.usedIngredientCount)) ingredient used"
            }
            
            if recipe.missedIngredientCount > 1 {
                lbNumofMissed.text = "\(String(recipe.missedIngredientCount)) ingredients missed"
            } else {
                lbNumofMissed.text = "\(String(recipe.missedIngredientCount)) ingredient missed"
            } 
        
            guard let url = URL(string: recipe.image)
                else {
                return
            }
            imageView.kf.setImage(with: url)
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbDishName: UILabel!
    @IBOutlet weak var lbNumofUsed: UILabel!
    @IBOutlet weak var lbNumofMissed: UILabel!
}
