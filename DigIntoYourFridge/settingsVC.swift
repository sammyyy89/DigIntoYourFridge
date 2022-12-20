import UIKit
import FacebookLogin
import FacebookCore

import Firebase
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

import RealmSwift

// MARK: - Body

class CellClass: UITableViewCell {
    
}

class settingsVC: UIViewController {
    
    @IBOutlet weak var btnSelectDiet: UIButton!
    //var myOptionBG = hexStringToUIColor(hex: "#FFC5A5")
    
    @IBOutlet weak var lbMain: UILabel!
    
    let transparentView = UIView()
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    var dataSource = [String]()
    var selectedValue = ""
    
    @IBOutlet weak var btnSave1: UIButton!
    @IBAction func saveBtn1Clicked(_ sender: Any) {
        let realm = try! Realm()
        let db = User()
        let currentUser = FirebaseAuth.Auth.auth().currentUser!.email ?? "Not found"
        
        let user = realm.objects(User.self).filter("userEmail == %@", currentUser).first!
        
        try! realm.write {
            user.diet = selectedValue
            realm.add(db, update: .all)
        }
        let addedAlert = UIAlertController(title: "Success", message: "Successfully saved!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print("diet added")
        }
        addedAlert.addAction(okAction)
        self.present(addedAlert, animated: false, completion: nil)
        
        //self.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = myYellow // set background color
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        
        let currentUser = FirebaseAuth.Auth.auth().currentUser?.email
        
        if !(currentUser == nil) {
            self.lbMain.isHidden = false
            self.btnSelectDiet.isHidden = false
            self.btnSave1.isHidden = false
            let realm = try! Realm()
            let user = realm.objects(User.self).filter("userEmail == %@", currentUser).first!
            
            if user.diet == "" {
                btnSelectDiet.setTitle("Diet: \(user.diet)", for: .normal)
            } else {
                self.lbMain.isHidden = true
                self.btnSelectDiet.isHidden = true
                self.btnSave1.isHidden = true
                btnSelectDiet.setTitle(user.diet, for: .normal)
            }
        } else { // anonymous user
            let alert = UIAlertController(title: "Alert", message: "Please login for additional features.", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                self.goToViewController(where: "loginPage")
            })
            
            alert.addAction(okay)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.connectedScenes.compactMap { ( $0 as? UIWindowScene)?.keyWindow }.first
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: 200)
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
    
    @IBAction func selectDietClicked(_ sender: Any) {
        dataSource = ["Pescetarian", "Lacto vegetarian", "Ovo vegetarian", "Vegan", "Paleo", "Primal", "Vegetarian", "None of above"]
        selectedButton = btnSelectDiet
        addTransparentView(frames: btnSelectDiet.frame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentUser = FirebaseAuth.Auth.auth().currentUser?.email
        
        if !(currentUser == nil) {
            self.lbMain.isHidden = false
            self.btnSelectDiet.isHidden = false
            self.btnSave1.isHidden = false
            let realm = try! Realm()
            let user = realm.objects(User.self).filter("userEmail == %@", currentUser).first!
            
            if user.diet == "" {
                btnSelectDiet.setTitle("Select Diet", for: .normal)
            } else {
                btnSelectDiet.setTitle("Diet: \(user.diet)", for: .normal)
            }
        } else { // anonymous user
            self.lbMain.isHidden = true
            self.btnSelectDiet.isHidden = true
            self.btnSave1.isHidden = true
            let alert = UIAlertController(title: "Alert", message: "Please login for additional features.", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                self.goToViewController(where: "loginPage")
            })
            
            alert.addAction(okay)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func goToViewController(where: String) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
}

extension settingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedValue = dataSource[indexPath.row]
    
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
    }
}



