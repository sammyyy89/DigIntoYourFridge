//
//  signupVC.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/6/22.
//

import UIKit
import FirebaseAuth
import RealmSwift

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
    @IBOutlet weak var lbSignedIn: UILabel!
    
    @IBOutlet weak var signOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = myYellow // set background color
        contentView.backgroundColor = myYellow // set content view color
        
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
        
        lbSignedIn.text = "You're already signed in!"
        lbSignedIn.font = UIFont(name: "Noteworthy", size: 20)
        lbSignedIn.translatesAutoresizingMaskIntoConstraints = false
        lbSignedIn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        lbSignedIn.topAnchor.constraint(equalTo: imgCake.bottomAnchor, constant: 30).isActive = true
        
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
        
        if FirebaseAuth.Auth.auth().currentUser != nil { // if current user exists
            userLoggedIn()
        } else {
            lbSignedIn.isHidden = true
            signOutBtn.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser == nil {
            tfName.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser != nil { // user logged in
            print("user tapped back button")
            userLoggedIn()
        } else {
            lbSignedIn.isHidden = true
            signOutBtn.isHidden = true
        }
    }
    
    @objc private func createBtnClicked() {
        guard let userName = tfName.text, !userName.isEmpty,
            let userEmail = tfEmail.text, !userEmail.isEmpty,
            let userPassword = tfPassword.text, !userPassword.isEmpty else {
                // if there are missing fields, show alert
                let alert = UIAlertController(title: "Required Fields Missing", message: "There are missing required fields!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
                return
            }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: userEmail, password: userPassword, completion: { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                // show account creation
                strongSelf.showCreateAccount(email: userEmail, password: userPassword)
                
                // add user email to db if it doesn't exist
                let realm = try! Realm()
                let db = User()
                
                db.userEmail = userEmail
                
                let exist = realm.object(ofType: User.self, forPrimaryKey: userEmail) // the result will be nil if the user does not exist
                
                if exist == nil {
                    try! realm.write {
                        realm.add(db)
                    }
                } else {
                    print("User already exists")
                    print("db: \(db)")
                }
                
                return
            }
            
            print("You have signed in")
            strongSelf.goToViewController(where: "mainPage")
            
            strongSelf.userLoggedIn()
            
            strongSelf.tfEmail.resignFirstResponder()
            strongSelf.tfPassword.resignFirstResponder()
        })
    }
    
    @objc private func signOutBtnClicked() {
        do {
            // 로그아웃 확인 컨펌 받는 알럿
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
            // 로그아웃 실패 시
            print("An error occurred")
        }
    }
    
    func goToViewController(where: String) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
    func userLoggedIn() {
        lbSignup.isHidden = false
        imgCake.isHidden = false
        lbName.isHidden = true
        tfName.isHidden = true
        lbEmail.isHidden = true
        tfEmail.isHidden = true
        lbPassword.isHidden = true
        tfPassword.isHidden = true
        lbSignedIn.isHidden = false
        signOutBtn.isHidden = false
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
                    // show account creation - If account creation fails, show why with an alert
                    print("Account creation failed")
    
                    let errMsg = error?.localizedDescription ?? "Error occurred"
                    
                    let errAlert = UIAlertController(title: "Account Creation Failed", message: errMsg, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    errAlert.addAction(ok)
                    
                    self?.present(errAlert, animated: true, completion: nil)
                    
                    self?.tfName.text = ""
                    self?.tfEmail.text = ""
                    self?.tfPassword.text = ""
                    
                    return
                }
                
                print("User signed in")
                strongSelf.goToViewController(where: "mainPage")
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
