//
//  homeVC.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/5/22.
//

import UIKit
import FirebaseAuth
import Foundation

class homeVC: UIViewController {
    
    @IBOutlet weak var UV: UIView!
    @IBOutlet weak var lbMain: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var btnGo: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let screenSize = UIScreen.main.bounds
    private var cellSize: CGSize!
    private var recipes = [Recipes]()
    
    fileprivate func prepareCellSize() {
        let width = ((screenSize.width-32)/2) * 0.9
        let height = width * 1.4
        cellSize = CGSize(width: width, height: height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareCellSize()
        
        fetchData { (posts) in
            
            for post in posts {
                print("ID: \(post.id!)")
                print("Dish: \(post.title)")
                print("image: \(post.image)")
                print("Image Type: \(post.imageType)")
                print("Used ingredients: \(post.usedIngredientCount)")
                print("Missed ingredients: \(post.missedIngredientCount)")
            
            }
        }
        
        self.view.backgroundColor = myYellow // set background color
        UV.backgroundColor = myYellow
        lbMain.textColor = lightPink
        searchBar.barTintColor = myYellow
        
        userEmail.text = ""
        userEmail.font = UIFont(name: "Noteworthy", size: 14)
        userEmail.translatesAutoresizingMaskIntoConstraints = false
        userEmail.centerXAnchor.constraint(equalTo: UV.centerXAnchor).isActive = true
        //userEmail.bottomAnchor.constraint(equalTo: lbMain.topAnchor, constant: 15).isActive = true
        //userEmail.trailingAnchor.constraint(equalTo: UV.trailingAnchor, constant: 10).isActive = true
        userEmail.widthAnchor.constraint(equalToConstant: 300).isActive = true
        userEmail.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if FirebaseAuth.Auth.auth().currentUser != nil { // if user is logged in
            currentUserName()
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let recipe = Recipes(title: "Some Dish Name here", image: "https://spoonacular.com/cdn/ingredients_100x100/apple.jpg", usedIngredientCount: 2, missedIngredientCount: 0)
        recipes.append(recipe)
        recipes.append(recipe)
    }
    
    func fetchData(completionHandler: @escaping ([Recipes]) -> Void) {
        
        let url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?ingredients=apples%2Cflour%2Csugar&number=5&ignorePantry=true&ranking=1")
        
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
                let recipeData = try JSONDecoder().decode([Recipes].self, from: data)
                
                completionHandler(recipeData)
            }
            catch {
                let error = error
                print(String(describing: error))
                //print("Error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func currentUserName() {
        if let currentUser = Auth.auth().currentUser {
            let userName = currentUser.displayName ?? "Display Name Not Found"
            let registeredEmail = currentUser.email ?? "Email Not Found"
            
            self.signinBtn.isHidden = true
            self.userEmail.isHidden = false
            
            if currentUser.providerData[0].providerID == "password"{
                self.userEmail.text = "You're signed in with \(registeredEmail)"
            } else {
                self.userEmail.text = "Hi, \(userName)"
            }
        }
    }
}

extension homeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("section: \(indexPath.section) row: \(indexPath.row)")
    }
}

extension homeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
//        cell.lbDishName.text = "Dish Name"
//        cell.lbNumofUsed.text = "Used: 1"
//        cell.lbNumofMissed.text = "Missed: 0"
        cell.recipe = recipes[indexPath.row]
        return cell
    }
}

extension homeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}

