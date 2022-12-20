//
//  searchIngredientsVC.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/18/22.
//

import UIKit
import FirebaseAuth
import Foundation
import RealmSwift

class searchIngredientsVC: UIViewController {
    private let screenSize = UIScreen.main.bounds
    private var cellSize: CGSize!
    private var ingredientData = [Ingredients]()
    
    private var userInput = ""
    private var intolerances = ""
    
    fileprivate func prepareCellSize() {
        let width = ((screenSize.width-32)/2) * 0.6
        let height = width * 1.2
        cellSize = CGSize(width: width, height: height)
    }
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lbMain: UILabel!
    @IBOutlet weak var lbSub: UILabel!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var btnGo: UIButton!
    
    @IBOutlet weak var lbNoResults: UILabel!
    
    @IBAction func btnClicked(_ sender: Any) {
        userInput = searchBar.text ?? ""
        
        fetchData {
            self.collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbNoResults.isHidden = true
        prepareCellSize()
        
        self.view.backgroundColor = myYellow // set background color
        contentView.backgroundColor = myYellow
        lbMain.textColor = lightPink
        
        
        lbMain.translatesAutoresizingMaskIntoConstraints = false
        lbMain.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        lbMain.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        
        lbSub.translatesAutoresizingMaskIntoConstraints = false
        lbSub.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        lbSub.topAnchor.constraint(equalTo: lbMain.bottomAnchor, constant: 3).isActive = true
        
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        searchBar.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
//
//        btnGo.translatesAutoresizingMaskIntoConstraints = false
//        btnGo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        btnGo.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 5).isActive = true
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        if FirebaseAuth.Auth.auth().currentUser != nil { // if user is logged in
            //currentUserName()
            print("test")
        }
    }
    
    func fetchData(completed: @escaping () -> ()) {
        
        let url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/food/ingredients/autocomplete?query=\(self.userInput)&number=100&intolerances=\(self.intolerances)")
        
        guard url != nil else {
                        print("Error creating url object")
                        let error = UIAlertController(title: "Error", message: "Error occured. Try again with a different ingredient", preferredStyle: .alert)
                        let okay = UIAlertAction(title: "OK", style: .default) { _ in
                
            }
                        error.addAction(okay)
                        self.present(error, animated: false, completion: nil)
                        return
                }
        
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy,
                                         timeoutInterval: 10.0)
        
        let header = ["X-RapidAPI-Key": "20a6998a90msh0516f8821cc4954p199178jsnf78c2b51a123",
                              "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"]
        
        request.allHTTPHeaderFields = header
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                self.ingredientData = try JSONDecoder().decode([Ingredients].self, from: data)
                
                if self.ingredientData.count > 0 {
                    DispatchQueue.main.async {
                        self.collectionView.isHidden = false
                        self.lbNoResults.isHidden = true
                        completed()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.collectionView.isHidden = true
                        self.lbNoResults.translatesAutoresizingMaskIntoConstraints = false
                        self.lbNoResults.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                        self.lbNoResults.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 20).isActive = true
                        self.lbNoResults.isHidden = false
                        self.lbNoResults.text = "No Results"
                    }
                }
            }
            catch {
                let error = error
                print(String(describing: error))
            }
        }.resume()
    }
    
    
//    func currentUserName() {
//        if let currentUser = Auth.auth().currentUser {
//            let userName = currentUser.displayName ?? "Display Name Not Found"
//            let registeredEmail = currentUser.email ?? "Email Not Found"
//
//            self.signinBtn.isHidden = true
//            self.userEmail.isHidden = false
//
//            if currentUser.providerData[0].providerID == "password"{
//                self.userEmail.text = "You're signed in with \(registeredEmail)"
//            } else {
//                self.userEmail.text = "Hi, \(userName)"
//            }
//        }
//    }
}

extension searchIngredientsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedName = ingredientData[indexPath.item].name
        // let selectedImage = ingredientData[indexPath.item].image
        
        let alert = UIAlertController(title: "Add ingredient", message: "Do you want to add this ingredient to your fridge?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { (action: UIAlertAction!) in
            let realm = try! Realm()
            let db = User()
            let currentUser = FirebaseAuth.Auth.auth().currentUser!.email ?? "Not found"
            
            let user = realm.objects(User.self).filter("userEmail == %@", currentUser).first!
           
            let exist = realm.object(ofType: User.self, forPrimaryKey: currentUser)
            
            if exist == nil {
                print("User not found")
            } else {
                try! realm.write {
                    user.ingredientsArray.append(selectedName)
                    realm.add(db, update: .all)
                }
                let addedAlert = UIAlertController(title: "Success", message: "Successfully added to your fridge!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    print("ingredient added")
                }
                addedAlert.addAction(okAction)
                self.present(addedAlert, animated: false, completion: nil)
                self.searchBar.text = ""
            }
        }
        alert.addAction(yes)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action: UIAlertAction!) in
            print("Cancel")
            let db = User() 
            print(db)
        }
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        // if clicked "yes" -> Add this ingredient to user's db
    }
}

extension searchIngredientsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredientData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! IG_CollectionViewCell
        
        cell.ingredient = ingredientData[indexPath.row]
        return cell
    }
}

extension searchIngredientsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize 
    }
}

class User: Object {
    @objc dynamic var userEmail: String = ""
    @objc dynamic var ingredient: String? = ""
    @objc dynamic var intolerance: String? = ""
    @objc dynamic var diet: String = "" // possible values: escetarian, lacto vegetarian, ovo vegetarian, vegan, paleo, primal, and vegetarian
    let ingredientsArray = List<String>()
    let intolerancesArray = List<String>() // possible values: dairy, egg, gluten, peanut, sesame, seafood, shellfish, soy, sulfite, tree nut, and wheat
    
    override static func primaryKey() -> String? {
        return "userEmail"
    }

}
