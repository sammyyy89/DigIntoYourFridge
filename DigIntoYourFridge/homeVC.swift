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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData { (posts) in
            
            for post in posts {
                print("Dish: \(post.title!)")
                print("image: \(post.image!)")
                print("Image Type: \(post.imageType!)")
                print(post.usedIngredientCount!)
                print(post.missedIngredientCount!)
            }
        }
        
//        // URL
//        let url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?ingredients=apples%2Cflour%2Csugar&number=5&ignorePantry=true&ranking=1")
//
//        guard url != nil else {
//                print("Error creating url object")
//                return
//        }
//        // URL Request
//        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy,
//                                 timeoutInterval: 10.0)
//
//        // Specify the header
//        let header = ["X-RapidAPI-Key": "20a6998a90msh0516f8821cc4954p199178jsnf78c2b51a123",
//                      "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"]
//
//        request.allHTTPHeaderFields = header
//
//        // Specify the body
//        let jsonObject = ["ingredients": ["apples", "flour", "sugar"],
//                          "number": 5,
//                          "ignorePantry": true,
//                          "ranking": 1] as [String : Any] // ranking: Whether to maximize used ingredients (1) or minimize missing ingredients (2) first.
//        do {
//            let requestBody = try JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
//            request.httpBody = requestBody
//        }
//        catch {
//            print("Error creating the data object from the json ")
//        }
//        // Set the request type
//        request.httpMethod = "POST"
//
//        // Get the URLSession
//        let session = URLSession.shared
//
//        // Create the data task
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            if (error != nil) {
//                print("Error: \(error)")
//            } else {
//                let httpResponse = response as? HTTPURLResponse
//                        print(httpResponse)
//            }
//        })
//
//        // Fire off the data task
//        dataTask.resume()
        
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


