//
//  regularCollectionViewCell.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 12/28/22.
//

import UIKit
import Kingfisher

class regularCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    
    var recipe: RegularRecipes! {
        didSet {
            lbTitle.text = recipe.title
            
            guard let url = URL(string: recipe.image) else { return }
            imageView.kf.setImage(with: url)
        }
    }
    
}
