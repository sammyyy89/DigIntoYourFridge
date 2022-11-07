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
        //userEmail.trailingAnchor.constraint(equalTo: UV.trailingAnchor, constant: 10).isActive = true
        userEmail.widthAnchor.constraint(equalToConstant: 300).isActive = true
        userEmail.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if FirebaseAuth.Auth.auth().currentUser != nil { // if user is logged in
            currentUserName()
        }
    }
    
    func currentUserName() {
        if let currentUser = Auth.auth().currentUser {
            let userName = currentUser.displayName ?? "Display Name Not Found"
            let registeredEmail = currentUser.email ?? "Email Not Found"
            
            self.signinBtn.isHidden = true
            self.userEmail.isHidden = false
            
            if currentUser.providerData[0].providerID == "password"{
                self.userEmail.text = "You're signed in with \(registeredEmail)"
            } else {
                self.userEmail.text = "Hi, \(userName)"
            }
        }
    }
}

