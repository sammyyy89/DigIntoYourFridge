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
    
    var userHas = List<String>()
    var igData = [Ingredients]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.isHidden = false
        self.collectionView.backgroundColor = myYellow
        
        collectionView.dataSource = self
        
        let currUser = FirebaseAuth.Auth.auth().currentUser?.email ?? "User not found"
        
        self.view.backgroundColor = myYellow // set background color
        if currUser == nil {
            self.lbMain.isHidden = true
            self.collectionView.isHidden = true
            let alert = UIAlertController(title: "Alert", message: "Please login for additional features.", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                self.goToViewController(where: "loginPage")
            })
            
            alert.addAction(okay)
            present(alert, animated: true, completion: nil)
        }
        else {
            self.collectionView.isHidden = false
            self.lbMain.isHidden = false
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
            self.lbMain.isHidden = true
            self.collectionView.isHidden = true
            let alert = UIAlertController(title: "Alert", message: "Please login for additional features.", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                self.goToViewController(where: "loginPage")
            })
            
            alert.addAction(okay)
            present(alert, animated: true, completion: nil)
        }
        else {
            self.lbMain.isHidden = false 
            self.collectionView.isHidden = false
            loadData()
        }
    }
    
    func loadData() {
        let currentUser = Auth.auth().currentUser?.email ?? "Not found"
        
        let realm = try! Realm()
        let data = realm.objects(User.self).filter("userEmail == %@", currentUser).first! // Thread 1: Fatal error: Unexpectedly found nil while unwrapping an Optional value
        self.userHas = data.ingredientsArray
        let joined = userHas.joined(separator: ", ")
    
        print("User has: \(joined)")
        
    }
    
//    func fetchData(completed: @escaping () -> ()) {
//        
//        let url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/food/ingredients/search?query=yogurt")
//        
//        guard url != nil else {
//                        print("Error creating url object")
//                        let error = UIAlertController(title: "Error", message: "Error occured.", preferredStyle: .alert)
//                        let okay = UIAlertAction(title: "OK", style: .default) { _ in
//                
//            }
//                        error.addAction(okay)
//                        self.present(error, animated: false, completion: nil)
//                        return
//                }
//        
//        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy,
//                                         timeoutInterval: 10.0)
//        
//        let header = ["X-RapidAPI-Key": "20a6998a90msh0516f8821cc4954p199178jsnf78c2b51a123",
//                              "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"]
//        
//        request.allHTTPHeaderFields = header
//        request.httpMethod = "GET"
//        
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { (data, response, error) in
//            
//            guard let data = data else { return }
//            
//            do {
//                self.igData = try JSONDecoder().decode([Ingredients].self, from: data)
//                
//                DispatchQueue.main.async {
//                    completed()
//                    }
//            }
//            catch {
//                let error = error
//                print(String(describing: error))
//            }
//        }.resume()
//    }
    
    func goToViewController(where: String) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
}

extension myFridgeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userHas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mfCell", for: indexPath) as! myFridgeCollectionViewCell
        
        cell.ingredientName.text = self.userHas[indexPath.row]
        
        return cell 
    }
}



