//
//  searchIngredientsVC.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/18/22.
//

//
//  homeVC.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/5/22.
//

import UIKit
import FirebaseAuth
import Foundation

class searchIngredientsVC: UIViewController {
    private let screenSize = UIScreen.main.bounds
    private var cellSize: CGSize!
    private var ingredientData = [Ingredients]()
    
    private var userInput = ""
    
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
    
    @IBAction func btnClicked(_ sender: Any) {
        userInput = searchBar.text ?? ""
        
        fetchData {
            self.collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/food/ingredients/autocomplete?query=\(self.userInput)&number=100&intolerances=apple")
        
        guard url != nil else {
                        print("Error creating url object")
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
                
                DispatchQueue.main.async {
                    completed()
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
        print("you clicked on me")
    }
}

extension searchIngredientsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredientData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! IG_CollectionViewCell
        //cell.lbIngredientName.text = "Spam"
        cell.ingredient = ingredientData[indexPath.row]
        return cell
    }
}

extension searchIngredientsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize 
    }
}
