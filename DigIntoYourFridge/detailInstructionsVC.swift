import UIKit
import Kingfisher

class detailInstructionsVC: UIViewController, UICollectionViewDataSource {

    //private var instructionData = [Instructions]()
    private var instructionData = [Step]()
    // private var equipmentData = [Equipments]()
    private var ingredientsRequired = [IngredientsForInst]()
    
    @IBOutlet weak var unavailableIngredients: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var id = ""
    var foodImgUrl = ""
    var name = ""
    var missedIgr = [String]()
    var usedIgr = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
         
        self.collectionView.dataSource = self
        print("id: \(id)")
//        print("Users don't have : \(missedIgr.joined(separator: ", "))")
        
        if missedIgr.count == 0 {
            unavailableIngredients.text = "Yay! You have every ingredient needed 😀"
            unavailableIngredients.textColor = .blue
        } else {
            unavailableIngredients.text = "🫤 \(missedIgr.joined(separator: ", ")) not in your fridge!"
            unavailableIngredients.textColor = .red
        }
        
        lbTitle.text = "\(name)"
        lbTitle.numberOfLines = 0
        
        guard let url = URL(string: "\(foodImgUrl)")
        else {
            return
        }
        
        img.kf.setImage(with: url)
        
        fetchData {
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.dataSource = self
        if missedIgr.count == 0 {
            unavailableIngredients.text = "Yay! You have every ingredient 😀"
            unavailableIngredients.textColor = .blue
        } else {
            unavailableIngredients.text = "🫤 \(missedIgr.joined(separator: ", ")) not in your fridge!"
            unavailableIngredients.textColor = .red
        }
//        unavailableIngredients.numberOfLines = 0
//        if unavailableIngredients.adjustsFontSizeToFitWidth == false {
//            unavailableIngredients.adjustsFontSizeToFitWidth = true
//        }
        lbTitle.text = "\(name)"
        lbTitle.numberOfLines = 0
        
        guard let url = URL(string: "\(foodImgUrl)")
        else {
            return
        }
        
        img.kf.setImage(with: url)
        
        fetchData {
            self.collectionView.reloadData()
        }
        
    }
    
    func fetchData(completed: @escaping () -> ()) {

        let url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/\(self.id)/analyzedInstructions?stepBreakdown=true")

        guard url != nil else {
                        print("Error creating url object")
                        let error = UIAlertController(title: "Error", message: "Error occured. Try again", preferredStyle: .alert)
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
                //self.instructionData = try JSONDecoder().decode([Instructions].self, from: data)
                let response = try JSONDecoder().decode([Instructions].self, from: data)
                self.instructionData = response.first?.steps ?? []
                
//                for item in self.instructionData[0].steps {
//                    print("Step \(item.number)")
//                    print("Instruction: \(item.step)")
//                }
                
                if self.instructionData.count > 0 {
                    DispatchQueue.main.async {
                        self.img.isHidden = false
                        self.unavailableIngredients.isHidden = false
                        completed()
                        // print("results: \(self.instructionData)")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.lbTitle.text = "No data"
                        self.img.isHidden = true
                        self.unavailableIngredients.isHidden = true
                        let alert = UIAlertController(title: "Alert", message: "Sorry, we're still working on this recipe.", preferredStyle: .alert)
                        let okay = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
                            self.goToViewController(where: "mainPage")
                        })
                        
                        alert.addAction(okay)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            catch {
                let error = error
                print(String(describing: error))
            }
        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instructionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "instCell", for: indexPath) as! instCell
        
        cell.stepNo.text = "🥣 Step \(instructionData[indexPath.row].number)"
        
        for item in instructionData[indexPath.row].ingredients {
            usedIgr.append(item.localizedName)
        }
        cell.step.text = "✔️ \(usedIgr.joined(separator: ", ")) \n\n\(instructionData[indexPath.row].step)"
        self.usedIgr = [String]()


        cell.step.isEditable = false
        cell.step.backgroundColor = myYellow
        //print("step: \(instructionData[indexPath.row].steps[indexPath.row].step) \n \(instructionData[indexPath.row].steps[indexPath.row].equipment[0].localizedName)")
        
        return cell
    }
    
    func goToViewController(where: String) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }

}



