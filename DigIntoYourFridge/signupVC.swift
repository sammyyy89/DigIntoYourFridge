//
//  signupVC.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/6/22.
//

import UIKit

class signupVC: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lbSignup: UILabel!
    @IBOutlet weak var imgCake: UIImageView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tfName: UITextField!
    
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var lbPassword: UILabel!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var createBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = myYellow // set background color
        contentView.backgroundColor = myYellow
        
        lbSignup.text = "Sign Up"
        lbSignup.font = UIFont(name: "Noteworthy", size: 35)
        
        imgCake.image = UIImage(named: "cake")
        imgCake.translatesAutoresizingMaskIntoConstraints = false
        imgCake.widthAnchor.constraint(equalToConstant: 120).isActive = true
        imgCake.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imgCake.topAnchor.constraint(equalTo: lbSignup.bottomAnchor, constant: 0).isActive = true
        imgCake.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -120).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalToConstant: 270).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 270).isActive = true
        stackView.topAnchor.constraint(equalTo: imgCake.bottomAnchor, constant: 15).isActive = true
        stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        
    }


}
