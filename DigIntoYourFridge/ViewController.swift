//
//  ViewController.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/5/22.
//

import UIKit
import FacebookLogin
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
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = myYellow // set background color
        AppName.textColor = myOrange
        lbSub.textColor = .black
        imgFood.image = UIImage(named: "Food on Table")
        
        // check Facebook Login status
        if let token = AccessToken.current,
           !token.isExpired {
            print("logged in")
        }
        else { // not logged in
            print("not logged in")
            
        }
        
        // Facebook Login Button customize + auto layout
        let fbLoginBtn = FBLoginButton()
        contentView.addSubview(fbLoginBtn)
        fbLoginBtn.translatesAutoresizingMaskIntoConstraints = false // should be set to false to use auto layout
        
        fbLoginBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        fbLoginBtn.bottomAnchor.constraint(equalTo: divider.bottomAnchor, constant: 100).isActive = true
        
        fbLoginBtn.widthAnchor.constraint(equalToConstant: 270).isActive = true
        fbLoginBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Google Login Button
        let ggLoginBtn = GIDSignInButton()
        contentView.addSubview(ggLoginBtn)
        
        
//        ggLoginBtn.translatesAutoresizingMaskIntoConstraints = false
//        
//        ggLoginBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        ggLoginBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -250).isActive = true
//        
//        ggLoginBtn.widthAnchor.constraint(equalToConstant: 270).isActive = true
//        ggLoginBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }


}

