//
//  detailInstructionsVC.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 12/19/22.
//

import UIKit
import Kingfisher

class detailInstructionsVC: UIViewController {
    
    //private var instructionData = [Instructions]()
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var foodImgUrl = ""
    var name = ""
    //var inst = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.isEditable = false
        lbTitle.text = "\(name)"
        
        guard let url = URL(string: "\(foodImgUrl)")
        else {
            return
        }
        
        img.kf.setImage(with: url)

        // Do any additional setup after loading the view.
    }

}
