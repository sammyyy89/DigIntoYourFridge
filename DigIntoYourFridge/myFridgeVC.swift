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
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currUser = FirebaseAuth.Auth.auth().currentUser?.email
        
        self.view.backgroundColor = myYellow // set background color
        if currUser == nil {
            let alert = UIAlertController(title: "Alert", message: "Please login for additional features.", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                self.goToViewController(where: "loginPage")
            })
            
            alert.addAction(okay)
            present(alert, animated: true, completion: nil)
        }
        else {
            loadData()
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        collectionView.collectionViewLayout = layout

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let currUser = FirebaseAuth.Auth.auth().currentUser?.email
        if currUser == nil {
            let alert = UIAlertController(title: "Alert", message: "Please login for additional features.", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                self.goToViewController(where: "loginPage")
            })
            
            alert.addAction(okay)
            present(alert, animated: true, completion: nil)
        }
        else {
            loadData()
        }
    }
    
    func loadData() {
        let currentUser = Auth.auth().currentUser?.email ?? "Not found"
        
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


