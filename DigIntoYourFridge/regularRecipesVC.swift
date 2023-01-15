import UIKit
import FacebookLogin
import FacebookCore

import Firebase
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

import RealmSwift

// MARK: - Body

class DietCellClass: UITableViewCell { }
class CuisineCellClass: UITableViewCell { }

class regularRecipesVC: UIViewController {
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
    private let screenSize = UIScreen.main.bounds
    private var cellSize: CGSize!
    private var userInput = ""
    
    @IBOutlet weak var lbSignIn: UIButton!
    @IBOutlet weak var btnChooseDiet: UIButton!
    @IBOutlet weak var btnSelectCuisine: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnGo: UIButton!
    
    @IBAction func btnClicked(_ sender: Any) {
        userInput = searchBar.text ?? ""
        
        if userInput == "" || userInput == nil {
            let alert = UIAlertController(title: "Required field missing", message: "Please enter the name of the dish.", preferredStyle: .alert)
            
            let OK = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            
            alert.addAction(OK)
            self.present(alert, animated: false, completion: nil)
        } else if selectedCuisineValue == "" || selectedCuisineValue == nil {
            let alert2 = UIAlertController(title: "Required field missing", message: "Please choose cuisine.", preferredStyle: .alert)
            
            let OK = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            
            alert2.addAction(OK)
            self.present(alert2, animated: false, completion: nil)
        }
        
        else {
            fetchData {
                self.collectionView.reloadData()
            }
        }
    }
    
    
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
    
    fileprivate func prepareCellSize() {
        let width = ((screenSize.width-32)/2) * 0.9
        let height = width * 1.4
        cellSize = CGSize(width: width, height: height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareCellSize()
        
        self.view.backgroundColor = myYellow // set background color
        tableView1.delegate = self
        tableView1.dataSource = self
        
        tableView2.delegate = self
        tableView2.dataSource = self
        
        tableView1.register(DietCellClass.self, forCellReuseIdentifier: "Cell")
        tableView2.register(CuisineCellClass.self, forCellReuseIdentifier: "cuisineCell")
        
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
                self.btnChooseDiet.setTitle("🌱 \(user?.diet ?? "None of Above")", for: .normal)
                self.selectedDietValue = user?.diet ?? ""
                print("diet value: \(self.selectedDietValue)")
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
    
    func fetchData(completed: @escaping () -> ()) {
        let currentUser = Auth.auth().currentUser?.email ?? "Not found"
        
        let encodedInput = self.urlEncode(encodedString: self.userInput)
        
        let encodedDiet = self.urlEncode(encodedString: self.selectedDietValue)
     
        let encodedCuisine = self.urlEncode(encodedString: self.selectedCuisineValue)

        let url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/complexSearch?query=\(encodedInput)&cuisine=\(encodedCuisine)&diet=\(encodedDiet)&sortDirection=asc")
            print(url)

        guard url != nil else {
            print("Error creating url object")
            let error = UIAlertController(title: "Error", message:"Error occured. Try again with a different ingredient", preferredStyle: .alert)
            let okay = UIAlertAction(title: "OK", style: .default) { _ in
                    
                }
            error.addAction(okay)
            self.present(error, animated: false, completion: nil)
            return
        }
            
        var request = URLRequest(url: url!, cachePolicy:.useProtocolCachePolicy,
                                    timeoutInterval: 10.0)
        
        let header = ["X-RapidAPI-Key": "20a6998a90msh0516f8821cc4954p199178jsnf78c2b51a123",
                        "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"]
            
        request.allHTTPHeaderFields = header
        request.httpMethod = "GET" // 31.50
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
                
            guard let data = data else { return }
                
            do {
                let response = try JSONDecoder().decode(Results.self, from: data)
                
                self.recipeData = response.results
                
                DispatchQueue.main.async {
                    //print("data test: \(self.recipeData)")
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

extension regularRecipesVC: UITableViewDelegate, UITableViewDataSource {
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

extension regularRecipesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destVC = storyboard?.instantiateViewController(withIdentifier: "detailInstructionsVC") as? detailInstructionsVC
        destVC?.id = String(recipeData[indexPath.row].id)
        destVC?.name = recipeData[indexPath.row].title
        destVC?.foodImgUrl = recipeData[indexPath.row].image
        destVC?.from = "regular"
        self.navigationController?.pushViewController(destVC!, animated: true)
    }
}

extension regularRecipesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! regularCollectionViewCell
        
        cell.recipe = recipeData[indexPath.row]
        return cell
    }
}

extension regularRecipesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}



// what to do: instruction page
// none of above 선택 시 처리, cuisine 안 골랐을 시 처리 -> 둘다 빈칸으로 처리
