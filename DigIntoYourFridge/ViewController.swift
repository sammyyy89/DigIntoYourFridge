//
//  ViewController.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/5/22.
//

import UIKit
import FacebookLogin
import FacebookCore

import FirebaseCore
import GoogleSignIn
import FirebaseAuth

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

class ViewController: UIViewController { 

    @IBOutlet weak var AppName: UILabel!
    @IBOutlet weak var lbSub: UILabel!
    @IBOutlet weak var imgFood: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var divider: UIView!
    
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
            
            Auth.auth().signIn(with: credential) { _, _ in
            }
            // If logged in successfully, display the app's main content view -> move to the main page
            print("Helloooooo")
            //self.fbBtn.isHidden = true
        }
    }
    
    @IBOutlet weak var fbBtn: UIButton!
    @IBAction func fbBtnClicked(_ sender: Any) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile"], from: self) {
            result, error in
            if let error = error {
                print("Encountered Error: \(error)")
            } else if let result = result, result.isCancelled {
                // user cancelled to login
                print("Cancelled")
            } else {
                // logged in successfully
                //print("Logged In")
                Profile.loadCurrentProfile { profile, error in
                    if let firstName = profile?.firstName {
                        print("Hello, \(firstName)")
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = myYellow // set background color
        AppName.textColor = myOrange
        lbSub.textColor = .black
        imgFood.image = UIImage(named: "Food on Table")
        
        // check Facebook Login status
//        if let token = AccessToken.current,
//           !token.isExpired {
//            print("logged in")
//        }
//        else { // not logged in
//            print("not logged in")
//
//        }
        
        // Google Login Button
        googleLoginBtn.backgroundColor = myWhite
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
        
    }

}


// 로그아웃 기능 구현 시 참고!! 원하는 곳(예를 들어 IBAction)에 아래 코드 작성.

//let firebaseAuth = Auth.auth()
//do {
//    try firebaseAuth.signOut()
//} catch let signOutError as NSError {
//    print("로그아웃 Error발생:", signOutError)
//}
