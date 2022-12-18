//
//  ViewController.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/5/22.
//

import UIKit
import FacebookLogin
import FacebookCore

import Firebase
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

import GoogleSignInSwift

import RealmSwift

// MARK: - Body

func hexStringToUIColor(hex: String) -> UIColor {
    var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xff0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

var myYellow = hexStringToUIColor(hex: "FFF8CB")
var myOrange = hexStringToUIColor(hex: "F98E71")
var lightPink = hexStringToUIColor(hex: "FFC5A5")
var fbBlue = hexStringToUIColor(hex: "#3b5998")
var myWhite = hexStringToUIColor(hex: "#ffffff")
var ggRed = hexStringToUIColor(hex: "DB4437")

class ViewController: UIViewController {
    
    @IBOutlet weak var lbSignedIn: UILabel!
    
    @IBOutlet weak var AppName: UILabel!
    @IBOutlet weak var lbSub: UILabel!
    @IBOutlet weak var imgFood: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lbOr: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = tfEmail.text, !email.isEmpty,
              let password = tfPassword.text, !password.isEmpty else {
                // if there are missing fields, show alert
                let alert = UIAlertController(title: "Required Fields Missing", message: "Please enter your email address and password.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
                return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { result, error in
            guard error == nil else {
                let errMsg = error?.localizedDescription ?? "Error occurred"
                
                let errAlert = UIAlertController(title: "Login Failed", message: errMsg, preferredStyle: .alert)
                let confirmed = UIAlertAction(title: "OK", style: .default, handler: nil)
                errAlert.addAction(confirmed)
                
                self.present(errAlert, animated: true, completion: nil)
                
                self.tfEmail.text = ""
                self.tfPassword.text = ""
                
                return
            }
            // signed in successfully
            
            // add user email to db if it doesn't exist
            let realm = try! Realm()
            let db = User()
            
            if db.userEmail.contains(email) {
                print("added")
                db.userEmail = email
                
                try! realm.write {
                    realm.add(db)
                }
            }
            else {
                print("already exists")
            }
            
            self.goToViewController(where: "mainPage")
            
            self.stackView.isHidden = true
            self.divider.isHidden = true
            self.lbOr.isHidden = true
            self.googleLoginBtn.isHidden = true
            self.fbBtn.isHidden = true
            self.lbSignedIn.isHidden = false
            self.signOutBtn.isHidden = false
        })
    }
    
    @IBOutlet weak var signOutBtn: UIButton!
    
    @IBOutlet weak var googleLoginBtn: UIButton!
    @IBAction func ggBtnAction(_ sender: GIDSignInButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [self] user, error in
            guard error == nil else { return }
            // 인증을 해도 계정은 따로 등록 필요
            // 구글 인증 토큰 받기 -> 사용자 정보 토큰 생성 -> 파이어베이스 인증에 등록
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken
            else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    print("Firebase auth fails with error: \(error.localizedDescription)")
                } else if let result = result {
                    print("Login success: \(result)")
                    
                    // add user email to db if it doesn't exist
                    let realm = try! Realm()
                    let db = User()
                    
                    let email = String(FirebaseAuth.Auth.auth().currentUser!.email ?? "")
                    db.userEmail = email
                    
                    let exist = realm.object(ofType: User.self, forPrimaryKey: email) // the result will be nil if the user does not exist
                    
                    if exist == nil {
                        try! realm.write {
                            realm.add(db)
                        }
                    } else {
                        print("User already exists")
                        print("db: \(db)")
                    }
                    
                    // If logged in successfully, display the app's main content view -> move to the main page
                    self.goToViewController(where: "mainPage")
                    
                    self.stackView.isHidden = true
                    self.divider.isHidden = true
                    self.lbOr.isHidden = true
                    self.googleLoginBtn.isHidden = true
                    self.fbBtn.isHidden = true
                    self.lbSignedIn.isHidden = false
                    self.signOutBtn.isHidden = false
                }
            }
        }
    }
    
    @IBOutlet weak var fbBtn: UIButton!
    @IBAction func fbBtnClicked(_ sender: Any) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { result, error in
            if let error = error {
                print("Encountered Error: \(error.localizedDescription)")
                return
            }
                guard let accessToken = AccessToken.current else {
                    print("Failed to get access token")
                    return
                }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                
                // Perform login by calling Firebase APIs
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if let error = error {
                        print("Firebase auth fails with error: \(error.localizedDescription)")
                    } else if let result = result {
                        print("Login success: \(result)")
                        
                        // add user email to db if it doesn't exist
                        let realm = try! Realm()
                        let db = User()
                        
                        let email = String(FirebaseAuth.Auth.auth().currentUser!.email ?? "Not found")
                        db.userEmail = email
                        
                        let exist = realm.object(ofType: User.self, forPrimaryKey: email) // the result will be nil if the user does not exist
                        
                        if exist == nil {
                            try! realm.write {
                                realm.add(db)
                            }
                            print("added: \(db)")
                        } else {
                            print("User already exists")
                            print("db: \(db)")
                        }
                        
                        self.goToViewController(where: "mainPage")
                        self.stackView.isHidden = true
                        self.divider.isHidden = true
                        self.lbOr.isHighlighted = true
                        self.googleLoginBtn.isHidden = true
                        self.fbBtn.isHidden = true
                        self.lbSignedIn.isHidden = false
                        self.signOutBtn.isHidden = false
                    }
                })
                
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = myYellow // set background color
        AppName.textColor = myOrange
        lbSub.textColor = .black
        imgFood.image = UIImage(named: "Food on Table")
        
        // Google Login Button
        googleLoginBtn.backgroundColor = ggRed
        googleLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        
        googleLoginBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        googleLoginBtn.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 50).isActive = true
        
        googleLoginBtn.widthAnchor.constraint(equalToConstant: 270).isActive = true
        googleLoginBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        googleLoginBtn.setTitle("Continue with Google", for: .normal)
        googleLoginBtn.titleLabel?.font =  UIFont(name: "Noteworthy", size: 17)
        
        // Facebook Login Button customize + auto layout
        fbBtn.backgroundColor = fbBlue
        fbBtn.translatesAutoresizingMaskIntoConstraints = false // should be set to false to use auto layout
        
        fbBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        fbBtn.topAnchor.constraint(equalTo: googleLoginBtn.bottomAnchor, constant: 20).isActive = true
        
        fbBtn.widthAnchor.constraint(equalToConstant: 270).isActive = true
        fbBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        fbBtn.titleLabel?.font = UIFont(name: "Noteworthy", size: 17)
        fbBtn.setTitle("Continue with Facebook", for: .normal)
        
        lbSignedIn.text = "You're already signed in!"
        lbSignedIn.font = UIFont(name: "Noteworthy", size: 20)
        lbSignedIn.translatesAutoresizingMaskIntoConstraints = false
        lbSignedIn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        lbSignedIn.topAnchor.constraint(equalTo: imgFood.bottomAnchor, constant: 30).isActive = true
        
        signOutBtn.translatesAutoresizingMaskIntoConstraints = false
        signOutBtn.setTitle("Sign Out", for: .normal)
        signOutBtn.titleLabel?.font = UIFont(name: "Noteworthy", size: 20)
        signOutBtn.backgroundColor = myOrange
        signOutBtn.widthAnchor.constraint(equalToConstant: 120).isActive = true
        signOutBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        signOutBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        signOutBtn.topAnchor.constraint(equalTo: lbSignedIn.bottomAnchor, constant: 15).isActive = true
        signOutBtn.addTarget(self, action: #selector(signOutBtnClicked), for: .touchUpInside)
        
        if FirebaseAuth.Auth.auth().currentUser != nil { // user logged in
            print("user logged in")
            stackView.isHidden = true
            divider.isHidden = true
            lbOr.isHidden = true
            googleLoginBtn.isHidden = true
            self.fbBtn.isHidden = true
            lbSignedIn.isHidden = false
            signOutBtn.isHidden = false
        } else {
            lbSignedIn.isHidden = true
            signOutBtn.isHidden = true
            
        }
        
        
        
        // check Facebook Login status
//        if let token = AccessToken.current,
//           !token.isExpired {
//            print("logged in")
//        }
//        else { // not logged in
//            print("not logged in")
//
//        }
    }
    
    @objc private func signOutBtnClicked() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            stackView.isHidden = false
            divider.isHidden = false
            lbOr.isHidden = false
            googleLoginBtn.isHidden = false
            fbBtn.isHidden = false
            lbSignedIn.isHidden = true
            
            signOutBtn.isHidden = true
            tfEmail.text = ""
            tfPassword.text = ""
        }
        catch {
            print("An error occurred")
        }
    }
    
    // keyboard
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tfEmail.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser != nil { // user logged in
            print("user logged in & tapped back button")
            stackView.isHidden = true
            divider.isHidden = true
            lbOr.isHidden = true
            googleLoginBtn.isHidden = true
            self.fbBtn.isHidden = true
            lbSignedIn.isHidden = false
            signOutBtn.isHidden = false
        } else {
            lbSignedIn.isHidden = true
            signOutBtn.isHidden = true
        }
    }
    
    func goToViewController(where: String) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
    func uploadToCloud() {
        print("cloud")
    }
}




// 로그아웃 기능 구현 시 참고!! 원하는 곳(예를 들어 IBAction)에 아래 코드 작성.

//let firebaseAuth = Auth.auth()
//do {
//    try firebaseAuth.signOut()
//} catch let signOutError as NSError {
//    print("로그아웃 Error발생:", signOutError)
//}
