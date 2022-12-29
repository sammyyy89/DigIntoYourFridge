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

class DietCellClass: UITableViewCell { }
class CuisineCellClass: UITableViewCell { }

class regularRecipeVC: UIViewController {
    @IBOutlet weak var lbSignIn: UIButton!
    @IBOutlet weak var btnChooseDiet: UIButton!
    @IBOutlet weak var btnSelectCuisine: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    
    let transparentView = UIView()
    let tableView1 = UITableView()
    
    let transparentView2 = UIView()
    let tableView2 = UITableView()
    
    var selectedDietBtn = UIButton()
    var selectedCuisineBtn = UIButton()
    
    var dataSourceforDiet = [String]()
    var dataSourceforCuisine = [String]()
    
    var selectedDietValue = ""
    var selectedCuisineValue = ""
    
    private var recipeData = [RegularRecipes]()
    
    @IBAction func signInBtnClicked(_ sender: Any) {
        self.goToViewController(where: "loginPage")
    }
    
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.connectedScenes.compactMap { ( $0 as? UIWindowScene)?.keyWindow }.first
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView1.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView1)
        tableView1.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView1.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView1.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: 200)
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedDietBtn.frame
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView1.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
    
    func addTransparentView2(frames: CGRect) {
        let window = UIApplication.shared.connectedScenes.compactMap { ( $0 as? UIWindowScene)?.keyWindow }.first
        transparentView2.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView2)
        
        tableView2.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView2)
        tableView2.layer.cornerRadius = 5
        
        transparentView2.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView2.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView2))
        transparentView2.addGestureRecognizer(tapGesture)
        transparentView2.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.transparentView2.alpha = 0.5
            self.tableView2.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: 200)
        }, completion: nil)
    }
    
    @objc func removeTransparentView2() {
        let frames = selectedCuisineBtn.frame
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.transparentView2.alpha = 0
            self.tableView2.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
    
    @IBAction func chooseDietClicked(_ sender: Any) {
        dataSourceforDiet = ["Pescetarian", "Lacto vegetarian", "Ovo vegetarian", "Vegan", "Paleo", "Primal", "Vegetarian", "None of above"]
            
            selectedDietBtn = btnChooseDiet
            addTransparentView(frames: btnChooseDiet.frame)
    }
    
    @IBAction func chooseCuisineClicked(_ sender: Any) {
        dataSourceforCuisine = ["African", "Chinese", "Japanese", "Korean", "Vietnamese", "Thai", "Indian", "British", "Irish", "French", "Italian", "Mexican", "Spanish", "Middle Eastern", "Jewish", "American", "Cajun", "Southern", "Greek", "German", "Nordic", "Eastern European", "Caribbean", "Latin American"]
        
        selectedCuisineBtn = btnSelectCuisine
        addTransparentView2(frames: btnSelectCuisine.frame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = myYellow // set background color
        tableView1.delegate = self
        tableView1.dataSource = self
        
        tableView2.delegate = self
        tableView2.dataSource = self
        
        tableView1.register(DietCellClass.self, forCellReuseIdentifier: "Cell")
        tableView2.register(CuisineCellClass.self, forCellReuseIdentifier: "cuisineCell")
        
        checkLoginStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkLoginStatus()
    }
    
    func checkLoginStatus() {
        let currUser = FirebaseAuth.Auth.auth().currentUser?.email
        
        if currUser == nil {
            self.lbSignIn.isHidden = false
            self.btnChooseDiet.isEnabled = true
        } else {
            self.lbSignIn.isHidden = true
            self.btnChooseDiet.isEnabled = false
            
            let realm = try! Realm()
            let user = realm.objects(User.self).filter("userEmail == %@", currUser).first
            
            if (user?.diet == "") || (user?.diet == nil) {
                let alert = UIAlertController(title: "Alert", message: "Please set your diet on Settings page.", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                    self.goToViewController(where: "settingsVC")
                })
                
                alert.addAction(okay)
                present(alert, animated: true, completion: nil)
            } else {
                self.btnChooseDiet.setTitle("🌱 \(user?.diet ?? "")", for: .normal)
            }
        }
    }
    
    func goToViewController(where: String) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
    func fetchData(completed: @escaping () -> ()) {
        let currUser = FirebaseAuth.Auth.auth().currentUser?.email
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("userEmail == %@", currUser).first
        
        var url = URL(string: "")
        
        if currUser == nil {
            url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/complexSearch?query=\(self.searchBar.text)&cuisine=\(self.selectedCuisineValue)&diet=\(self.selectedDietValue)&sortDirection=asc")
        } else {
            url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/complexSearch?query=\(self.searchBar.text)&cuisine=\(self.selectedCuisineValue)&diet=\(user?.diet ?? "")&sortDirection=asc")
        }
        
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
                self.recipeData = try JSONDecoder().decode([RegularRecipes].self, from: data)
                
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
}

extension regularRecipeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            return dataSourceforDiet.count
        } else {
            return dataSourceforCuisine.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView1 {
            let dietCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            dietCell.textLabel?.text = dataSourceforDiet[indexPath.row]
            return dietCell
        } else {
            let cuisineCell = tableView2.dequeueReusableCell(withIdentifier: "cuisineCell", for: indexPath)
            cuisineCell.textLabel?.text = dataSourceforCuisine[indexPath.row]
            return cuisineCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView1 {
            selectedDietValue = dataSourceforDiet[indexPath.row]
            selectedDietBtn.setTitle(dataSourceforDiet[indexPath.row], for: .normal)
            removeTransparentView()
        } else {
            selectedCuisineValue = dataSourceforCuisine[indexPath.row]
            selectedCuisineBtn.setTitle(dataSourceforCuisine[indexPath.row], for: .normal)
            removeTransparentView2()
        }
    }
}


