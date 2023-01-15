//
//  homeVC.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/5/22.
//

import UIKit
import FirebaseAuth
import Foundation
import RealmSwift
import Kingfisher

class homeVC: UIViewController {
    
    @IBOutlet weak var UV: UIView!
    @IBOutlet weak var lbMain: UILabel!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var btnGo: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let screenSize = UIScreen.main.bounds
    private var cellSize: CGSize!
    private var recipeData = [Recipes]()
    private var missedIgr = [Missed]()
    private var usedIgr = [Used]()
    
    private var missed = [String]()
    private var used = [String]()
    
    fileprivate func prepareCellSize() {
        let width = ((screenSize.width-32)/2) * 0.9
        let height = width * 1.4
        cellSize = CGSize(width: width, height: height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareCellSize()
        
        self.view.backgroundColor = myYellow // set background color
        UV.backgroundColor = myYellow
        lbMain.textColor = lightPink
        
        userEmail.text = ""
        userEmail.font = UIFont(name: "Noteworthy", size: 14)
        userEmail.translatesAutoresizingMaskIntoConstraints = false
        userEmail.centerXAnchor.constraint(equalTo: UV.centerXAnchor).isActive = true
        userEmail.widthAnchor.constraint(equalToConstant: 300).isActive = true
        userEmail.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        checkLoginStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        checkLoginStatus()
    }
    
    func checkLoginStatus() {
        let currUser = FirebaseAuth.Auth.auth().currentUser?.email

        if currUser == nil { // anonymous user
            self.UV.isHidden = true
            self.goToViewController(where: "regularRecipesPage")
        } else {
            self.UV.isHidden = false
            currentUserName()
            fetchData {
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchData(completed: @escaping () -> ()) {
        
        let currentUser = Auth.auth().currentUser?.email ?? "Not found"

        let realm = try! Realm()
        let data = realm.objects(User.self).filter("userEmail == %@", currentUser).first
        if data == nil {
            print("no data to display")
        } else {
            let userHas = data?.ingredientsArray
            let joined = userHas?.joined(separator: ",")

            let strEncoded = self.urlEncode(encodedString: "\(joined)") // comma = %2C, blank = %20
            print("str: \(strEncoded)")

            let url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?ingredients=\(strEncoded)&number=50&ignorePantry=false&ranking=2")
            // ignorePantry = Whether to ignore pantry ingredients such as water, salt, flour, etc.
            // ranking = maximize used ingredients = 1, minimze missing ingredients = 2
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
                    self.recipeData = try JSONDecoder().decode([Recipes].self, from: data)

                    DispatchQueue.main.async {
                        completed()
                    }
                }
                catch {
                    let error = error
                    print(String(describing: error))
                    //print("Error: \(error.localizedDescription)")
                }
            }.resume()
        }
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
    
    func urlEncode(encodedString: String) -> String {
        let allowedChars = encodedString.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "\"#%/<>?@,\\^`{|} ").inverted) ?? ""
        return allowedChars
    }
    
    func goToViewController(where: String) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
}

extension homeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.missed = [String]()
        self.used = [String]()
        
        self.missedIgr = self.recipeData[indexPath.row].missedIngredients
        for missed in self.missedIgr {
            self.missed.append(missed.name)
        }
        
        self.usedIgr = self.recipeData[indexPath.row].usedIngredients
        for used in self.usedIgr {
            self.used.append(used.name)
        }
        
//        print("missed: \(self.missed)")
        
        let destVC = storyboard?.instantiateViewController(withIdentifier: "detailInstructionsVC") as? detailInstructionsVC
        destVC?.id = String(recipeData[indexPath.row].id)
        destVC?.name = recipeData[indexPath.row].title
        destVC?.foodImgUrl = recipeData[indexPath.row].image
        destVC?.missedIgr = self.missed
        destVC?.usedIgr = self.used

        self.navigationController?.pushViewController(destVC!, animated: true)
    }
}

extension homeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
    
        cell.recipe = recipeData[indexPath.row]
        return cell
    }
}

extension homeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}


   

