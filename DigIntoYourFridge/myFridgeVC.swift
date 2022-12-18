import UIKit
import FacebookLogin
import FacebookCore

import Firebase
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

import RealmSwift

// MARK: - Body


class myFridgeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = myYellow // set background color
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        let currentUser = Auth.auth().currentUser?.email ?? "Not found"
        //print("user: \(currentUser)")
        let realm = try! Realm()
        let data = realm.objects(User.self).filter("userEmail == %@", currentUser).first!
        let userHas = data.ingredientsArray
        let joined = userHas.joined(separator: ",")
        
        print("User has: \(joined)")
    }
    
    func goToViewController(where: String) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
}

