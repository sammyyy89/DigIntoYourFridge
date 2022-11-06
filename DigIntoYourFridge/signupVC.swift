//
//  signupVC.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/6/22.
//

import UIKit
import FirebaseAuth

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
    
    @IBOutlet weak var signIn: UIButton!
    
    @IBOutlet weak var signOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signOutBtn.isHidden = true
        
        self.view.backgroundColor = myYellow // set background color
        contentView.backgroundColor = myYellow
        
        lbSignup.text = "Sign Up"
        lbSignup.font = UIFont(name: "Noteworthy", size: 35)
        
        imgCake.image = UIImage(named: "cake")
        imgCake.translatesAutoresizingMaskIntoConstraints = false
        imgCake.widthAnchor.constraint(equalToConstant: 120).isActive = true
        imgCake.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imgCake.topAnchor.constraint(equalTo: lbSignup.bottomAnchor, constant: 0).isActive = true
        imgCake.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: 0).isActive = true
        imgCake.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -120).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalToConstant: 270).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 310).isActive = true
        stackView.topAnchor.constraint(equalTo: imgCake.bottomAnchor, constant: 20).isActive = true
        stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        lbName.translatesAutoresizingMaskIntoConstraints = false
        lbName.text = "Name"
        lbName.font = UIFont(name: "Noteworthy", size: 17)
        
        lbEmail.translatesAutoresizingMaskIntoConstraints = false
        lbEmail.text = "Email Address"
        lbEmail.font = UIFont(name: "Noteworthy", size: 17)
        
        tfEmail.autocapitalizationType = .none
        tfEmail.leftViewMode = .always
        tfEmail.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        lbPassword.translatesAutoresizingMaskIntoConstraints = false
        lbPassword.text = "Password"
        lbPassword.font = UIFont(name: "Noteworthy", size: 17)
        
        tfPassword.isSecureTextEntry = true
        if #available(iOS 12.0, *) {
            tfPassword.textContentType = .oneTimeCode
        }
        
        tfPassword.autocapitalizationType = .none
        tfPassword.leftViewMode = .always
        tfPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        createBtn.setTitle("Create an Account", for: .normal)
        createBtn.titleLabel?.font =  UIFont(name: "Noteworthy", size: 17)
        createBtn.backgroundColor = myOrange
        createBtn.addTarget(self, action: #selector(createBtnClicked), for: .touchUpInside)
        
        signOutBtn.translatesAutoresizingMaskIntoConstraints = false
        signOutBtn.setTitle("Sign Out", for: .normal)
        signOutBtn.titleLabel?.font = UIFont(name: "Noteworthy", size: 20)
        signOutBtn.backgroundColor = myOrange
        signOutBtn.widthAnchor.constraint(equalToConstant: 120).isActive = true
        signOutBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        signOutBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        signOutBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        signOutBtn.addTarget(self, action: #selector(signOutBtnClicked), for: .touchUpInside)
        
        
        signIn.setTitle("Already a member? Sign in", for: .normal)
        signIn.titleLabel?.font = UIFont(name: "Noteworthy", size: 15)
        
        signIn.translatesAutoresizingMaskIntoConstraints = false
        signIn.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20).isActive = true
        signIn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            lbSignup.isHidden = true
            imgCake.isHidden = true
            lbName.isHidden = true
            tfName.isHidden = true
            lbEmail.isHidden = true
            tfEmail.isHidden = true
            lbPassword.isHidden = true
            tfPassword.isHidden = true
            createBtn.isHidden = true
            signIn.isHidden = true
            
            signOutBtn.isHidden = false 
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser == nil {
            tfName.becomeFirstResponder()
        }
    }
    
    @objc private func createBtnClicked() {
        guard let userEmail = tfEmail.text, !userEmail.isEmpty,
            let userPassword = tfPassword.text, !userPassword.isEmpty else {
                print("Missing field data")
                return
        }
        
        
        // Get auth instance
        
        // attempt sign in
        
        // if failure, present alert to create account
        
        // if user continues, create account
        
        // check sign in on app launch
        
        // allow user to sign out with button
        
        FirebaseAuth.Auth.auth().signIn(withEmail: userEmail, password: userPassword, completion: { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                // show account creation
                strongSelf.showCreateAccount(email: userEmail, password: userPassword)
                return
            }
            
            print("You have signed in")
            strongSelf.lbSignup.isHidden = true
            strongSelf.imgCake.isHidden = true
            strongSelf.lbName.isHidden = true
            strongSelf.tfName.isHidden = true
            strongSelf.lbEmail.isHidden = true
            strongSelf.tfEmail.isHidden = true
            strongSelf.lbPassword.isHidden = true
            strongSelf.tfPassword.isHidden = true
            strongSelf.createBtn.isHidden = true
            strongSelf.signIn.isHidden = true
            
            strongSelf.tfEmail.resignFirstResponder()
            strongSelf.tfPassword.resignFirstResponder()
        })
    }
    
    @objc private func signOutBtnClicked() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            lbSignup.isHidden = false
            imgCake.isHidden = false
            lbName.isHidden = false
            tfName.isHidden = false
            lbEmail.isHidden = false
            tfEmail.isHidden = false
            lbPassword.isHidden = false
            tfPassword.isHidden = false
            createBtn.isHidden = false
            signIn.isHidden = false
            
            signOutBtn.isHidden = true
        }
        catch {
            print("An error occurred")
        }
    }
    
    func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Create Account", message: "Would you like to create an account?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
                guard let strongSelf = self else {
                    return
                }
                
                guard error == nil else {
                    // show account creation
                    print("Account creation failed")
                    return
                }
                
                print("You have signed in")
                strongSelf.lbSignup.isHidden = true
                strongSelf.imgCake.isHidden = true
                strongSelf.lbName.isHidden = true
                strongSelf.tfName.isHidden = true
                strongSelf.lbEmail.isHidden = true
                strongSelf.tfEmail.isHidden = true
                strongSelf.lbPassword.isHidden = true
                strongSelf.tfPassword.isHidden = true
                strongSelf.createBtn.isHidden = true
                strongSelf.signIn.isHidden = true
                
                strongSelf.tfEmail.resignFirstResponder()
                strongSelf.tfPassword.resignFirstResponder()
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            
        }))
        present(alert, animated: true)
    }
}
