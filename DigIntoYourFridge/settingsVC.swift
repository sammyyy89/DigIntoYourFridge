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

class MultipleSelection_ColCell: UICollectionViewCell {
    
    @IBOutlet weak var viewForSelection: UIView!
    @IBOutlet weak var lbOption: UILabel!
}

class settingsVC: UIViewController {
    
    @IBOutlet weak var usersIntolerances: UILabel!
    
    @IBOutlet weak var intolerancesCollectionView: UICollectionView!
    
    @IBOutlet weak var btnSelectDiet: UIButton!
    //var myOptionBG = hexStringToUIColor(hex: "#FFC5A5")
    
    @IBOutlet weak var lbMain: UILabel!
    @IBOutlet weak var topBtn: UIButton!
    @IBOutlet weak var lbIntolerances: UILabel!
    
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
        
        let user = realm.objects(User.self).filter("userEmail == %@", currentUser).first
        
        if user == nil {
            print("no data")
        } else {
            try! realm.write {
                user?.diet = selectedValue
                realm.add(db, update: .all)
            }
            let addedAlert = UIAlertController(title: "Success", message: "Successfully saved!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in

            }
            addedAlert.addAction(okAction)
            self.present(addedAlert, animated: false, completion: nil)
        }
    }
    
    var intolerances = ["Dairy", "Egg", "Gluten", "Peanut", "Sesame", "Seafood", "Shellfish", "Soy", "Sulfite", "Tree Nut", "Wheat"]
    var selectedIndex = [-1]
    var selectedIntolerances = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = myYellow // set background color
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        
        checkLoginStatus()
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
        dataSource = ["Pescetarian", "Lacto vegetarian", "Ovo vegetarian", "Vegan", "Paleo", "Primal", "Vegetarian", "None"]
        selectedButton = btnSelectDiet
        addTransparentView(frames: btnSelectDiet.frame)
    }
    
    @IBOutlet weak var saveIntBtn: UIButton!
    @IBAction func saveIntBtnClicked(_ sender: Any) {
        for value in selectedIntolerances {
            let realm = try! Realm()
            let db = User()
            let currentUser = FirebaseAuth.Auth.auth().currentUser!.email ?? "Not found"
            
            let user = realm.objects(User.self).filter("userEmail == %@", currentUser).first!
            
            let exist = realm.object(ofType: User.self, forPrimaryKey: currentUser)
            
            if exist == nil {
                print("error")
            } else {
                for value in selectedIntolerances {
                    if user.intolerancesArray.contains(value) {
                        print("Already added")
                    } else {
                        try! realm.write {
                            user.intolerancesArray.append(value)
                            realm.add(db, update: .all)
                        }
                        let addedAlert = UIAlertController(title: "Intolerances added", message: "Intolerances successfully added!", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) {
                            (action) in
                            self.intolerancesCollectionView.reloadData()
                            self.viewDidLoad()
                        }
                        addedAlert.addAction(okAction)
                        self.present(addedAlert, animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var resetBtn: UIButton!
    @IBAction func detBtnClicked(_ sender: Any) {
        let realm = try! Realm()
        let currentUser = FirebaseAuth.Auth.auth().currentUser!.email ?? "Not found"
            
        let user = realm.objects(User.self).filter("userEmail == %@", currentUser).first!
            
        let exist = realm.object(ofType: User.self, forPrimaryKey: currentUser)
            
        if exist == nil {
            print("noting found")
        } else {
            let confirm = UIAlertController(title: "Are you sure?", message: "Do you want to delete every intolerance?", preferredStyle: .alert)
            
            let yes = UIAlertAction(title: "Delete", style: .destructive) { _ in
                if user.intolerancesArray.count > 0 {
                    try! realm.write {
                        user.intolerancesArray.removeAll()
                        self.viewDidLoad()
                    }
                } else {
                    print("already empty")
                }
            }
            let no = UIAlertAction(title: "Cancel", style: .cancel) {
                _ in
                print("Cancelled")
            }
            confirm.addAction(no)
            confirm.addAction(yes)
            present(confirm, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkLoginStatus()
    }
    
    func checkLoginStatus() {
        let currUser = FirebaseAuth.Auth.auth().currentUser?.email
        
        if currUser == nil {
            self.lbMain.isHidden = true
            self.btnSelectDiet.isHidden = true
            self.btnSave1.isHidden = true
            self.intolerancesCollectionView.isHidden = true
            self.topBtn.isHidden = true
            self.lbIntolerances.isHidden = true
            self.usersIntolerances.isHidden = true
            self.saveIntBtn.isHidden = true
            self.resetBtn.isHidden = true
            let alert = UIAlertController(title: "Alert", message: "Please login for additional features.", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                self.goToViewController(where: "loginPage")
            })
            
            alert.addAction(okay)
            present(alert, animated: true, completion: nil)
        } else {
            self.lbMain.isHidden = false
            self.btnSelectDiet.isHidden = false
            self.btnSave1.isHidden = false
            self.intolerancesCollectionView.isHidden = false
            self.topBtn.isHidden = false
            self.lbIntolerances.isHidden = false
            self.lbIntolerances.isHidden = false
            self.saveIntBtn.isHidden = false
            self.resetBtn.isHidden = false
            let realm = try! Realm()
            let user = realm.objects(User.self).filter("userEmail == %@", currUser).first
            
            if user?.intolerancesArray == nil {
                self.usersIntolerances.text = "Your intolerances: "
            } else {
                let allergicTo = user?.intolerancesArray
                self.usersIntolerances.text = "Your intolerances:  \(allergicTo!.joined(separator: ", "))"
            }
            
            
            
            if (user?.diet == "") || (user?.diet == nil) {
                btnSelectDiet.setTitle("🌱 Select Diet", for: .normal)
            } else {
                btnSelectDiet.setTitle("🌱 Diet: \(user?.diet ?? "")", for: .normal)
            }
            
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

extension settingsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return intolerances.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = intolerancesCollectionView.dequeueReusableCell(withReuseIdentifier: "MultipleSelection_ColCell", for: indexPath) as! MultipleSelection_ColCell
        
        cell.lbOption.text = intolerances[indexPath.row]
        
//        let realm = try! Realm()
//        let db = User()
//        let currentUser = FirebaseAuth.Auth.auth().currentUser!.email ?? "Not found"
//        let user = realm.objects(User.self).filter("userEmail == %@", currentUser).first!
        
        if selectedIndex.contains(indexPath.item) {
            cell.viewForSelection.backgroundColor = myOrange
            cell.lbOption.textColor = myYellow
        } else {
            cell.viewForSelection.backgroundColor = myYellow
            cell.lbOption.textColor = .black
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.intolerancesCollectionView.frame.width / 5 - 5, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex.contains(indexPath.item) {
            if let index = selectedIndex.firstIndex(of: indexPath.item) {
                selectedIndex.remove(at: index)
                
                let itemToRemove = intolerances[indexPath.item]
                while selectedIntolerances.contains(itemToRemove) {
                    if let idx = selectedIntolerances.firstIndex(of: itemToRemove) {
                        selectedIntolerances.remove(at: idx)
                    }
                }
            }
        } else {
            selectedIndex.append(indexPath.item)
            selectedIntolerances.append(intolerances[indexPath.item])
        }
        intolerancesCollectionView.reloadData()
        let joined = selectedIntolerances.joined(separator: ",")
    }
}



