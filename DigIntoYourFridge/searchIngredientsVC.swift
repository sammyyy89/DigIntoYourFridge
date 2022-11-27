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
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lbMain: UILabel!
    @IBOutlet weak var lbSub: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnGo: UIButton!
    @IBOutlet weak var lbIntolerances: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData { (posts) in
            
            for post in posts {
                print("Name: \(post.name!)")
                print("image: \(post.image!)") // https://spoonacular.com/food-api/docs#Show-Images
            }
        }
        
        self.view.backgroundColor = myYellow // set background color
        contentView.backgroundColor = myYellow
        lbMain.textColor = lightPink
        searchBar.barTintColor = myYellow
        
        lbMain.translatesAutoresizingMaskIntoConstraints = false
        lbMain.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        lbMain.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80).isActive = true
        
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
        
        lbIntolerances.translatesAutoresizingMaskIntoConstraints = false
        lbIntolerances.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        lbIntolerances.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true 
        
        
        if FirebaseAuth.Auth.auth().currentUser != nil { // if user is logged in
            //currentUserName()
            print("test")
        }
    }
    
    func fetchData(completionHandler: @escaping ([Ingredients]) -> Void) {
        
        let url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/food/ingredients/autocomplete?query=apple&number=10&intolerances=egg")
        
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
                let recipeData = try JSONDecoder().decode([Ingredients].self, from: data)
                
                completionHandler(recipeData)
            }
            catch {
                let error = error
                print(String(describing: error))
                //print("Error: \(error.localizedDescription)")
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


