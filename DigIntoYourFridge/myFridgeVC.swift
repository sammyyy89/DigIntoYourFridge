import UIKit
import FacebookLogin
import FacebookCore

import Firebase
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

import RealmSwift
import Kingfisher

// MARK: - Body

class myFridgeVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var lbMain: UILabel!
    @IBOutlet weak var moveBtn: UIButton!
    
    var userHas = List<String>()
    var saved_images = List<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.isHidden = false
        self.collectionView.backgroundColor = myYellow
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.view.backgroundColor = myYellow // set background color
        checkLoginStatus()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        collectionView.collectionViewLayout = layout

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        
        checkLoginStatus()
    }
    
    func checkLoginStatus() {
        let currUser = FirebaseAuth.Auth.auth().currentUser?.email
        
        if currUser == nil { // anonymous user
            self.lbMain.isHidden = true
            self.collectionView.isHidden = true
            self.moveBtn.isHidden = true
            let alert = UIAlertController(title: "Alert", message: "Please login for additional features.", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                self.goToViewController(where: "loginPage")
            })
            
            alert.addAction(okay)
            present(alert, animated: true, completion: nil)
        } else {
            self.lbMain.isHidden = false
            self.collectionView.isHidden = false
            self.moveBtn.isHidden = false 
            loadData()
        }
    }
    
    func loadData() {
        let currentUser = Auth.auth().currentUser?.email ?? "Not found"
        let realm = try! Realm()
        let data = realm.objects(User.self).filter("userEmail == %@", currentUser).first
        
        if data == nil {
            print("No data")
        } else {
            let exist = realm.object(ofType: User.self, forPrimaryKey: currentUser)
            
            if exist == nil {
                print("not found")
            } else {
                self.userHas = data!.ingredientsArray
                self.saved_images = data!.imgUrlArray
                let joined = userHas.joined(separator: ", ")
                let img_joined = saved_images.joined(separator: ", ")
            }
        }
    }
    
    func goToViewController(where: String) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
}

extension myFridgeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedName = self.userHas[indexPath.row]
        let selectedImg = self.saved_images[indexPath.row]

        let realm = try! Realm()
        let db = User()
        let currentUser = FirebaseAuth.Auth.auth().currentUser!.email ?? "Not found"
        
        let match = realm.objects(User.self).filter("userEmail == %@", currentUser).first!
        
        let exist = realm.object(ofType: User.self, forPrimaryKey: currentUser)
        
        if exist == nil {
            print("Error finding user")
        } else {
            let confirm = UIAlertController(title: "Are you sure?", message: "Do you want to delete this ingredient from your fridge?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Delete", style: .destructive) { _ in
                try! realm.write {
                    match.ingredientsArray.remove(at: indexPath.row)
                    match.imgUrlArray.remove(at: indexPath.row)
                }
                self.goToViewController(where: "myFridgeVC")
            }
            
            let no = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                print("Cancelled")
            }
            confirm.addAction(no)
            confirm.addAction(yes)
            present(confirm, animated: true, completion: nil)
        }
    }
}

extension myFridgeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.saved_images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mfCell", for: indexPath) as! myFridgeCollectionViewCell
        
        cell.ingredientName.text = self.userHas[indexPath.row]
                
        let cellImage = self.saved_images[indexPath.row]
                
        if let url = URL(string: "https://spoonacular.com/cdn/ingredients_100x100/\(cellImage)") {
            cell.ingredientImg.kf.setImage(with: url)
        } else {
            print("no image")
        }
        return cell
    }
}



