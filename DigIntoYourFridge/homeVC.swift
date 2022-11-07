//
//  homeVC.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/5/22.
//

import UIKit
import FirebaseAuth

class homeVC: UIViewController {

    @IBOutlet weak var UV: UIView!
    @IBOutlet weak var lbMain: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = myYellow // set background color
        UV.backgroundColor = myYellow
        lbMain.textColor = lightPink
        searchBar.barTintColor = myYellow
        
        userEmail.text = ""
        userEmail.font = UIFont(name: "Noteworthy", size: 14)
        userEmail.translatesAutoresizingMaskIntoConstraints = false
        userEmail.centerXAnchor.constraint(equalTo: UV.centerXAnchor).isActive = true
        //userEmail.bottomAnchor.constraint(equalTo: lbMain.topAnchor, constant: 15).isActive = true
        //userEmail.leadingAnchor.constraint(equalTo: UV.leadingAnchor, constant: 100).isActive = true
        userEmail.widthAnchor.constraint(equalToConstant: 300).isActive = true
        userEmail.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if FirebaseAuth.Auth.auth().currentUser != nil { // if user is logged in
            signinBtn.isHidden = true
            userEmail.isHidden = false
            
            let user = Auth.auth().currentUser
            if let user = user {
                if let registeredEmail = user.email {
                    userEmail.text = "Logged in with \(registeredEmail)"
                }
            }
        } else {
            signinBtn.isHidden = false
            userEmail.isHidden = true
        }
    }


}
