//
//  instCell.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 12/20/22.
//

import UIKit

class instCell: UITableViewCell {
    
    @IBOutlet weak var stepNo: UILabel!
    @IBOutlet weak var step: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

