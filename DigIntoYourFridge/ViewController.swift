//
//  ViewController.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/5/22.
//

import UIKit
import FacebookLogin

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
            // Facebook Login Button customize + auto layout
            let fbLoginBtn = FBLoginButton()
            contentView.addSubview(fbLoginBtn)
            fbLoginBtn.translatesAutoresizingMaskIntoConstraints = false // should be set to false to use auto layout
            
            fbLoginBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            fbLoginBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -120).isActive = true
            
            fbLoginBtn.widthAnchor.constraint(equalToConstant: 270).isActive = true
            fbLoginBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
        }
        
    }


}

