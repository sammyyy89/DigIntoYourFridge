import UIKit
import Kingfisher

class detailInstructionsVC: UIViewController, UICollectionViewDataSource {

    //private var instructionData = [Instructions]()
    private var instructionData = [Step]()
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var id = ""
    var foodImgUrl = ""
    var name = ""

    override func viewDidLoad() {
        super.viewDidLoad()
         
        self.collectionView.dataSource = self
        print("id: \(id)")
        lbTitle.text = "\(name)"
        lbTitle.numberOfLines = 0
        
        guard let url = URL(string: "\(foodImgUrl)")
        else {
            return
        }
        
        img.kf.setImage(with: url)
        
//        let urlString = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/\(self.id)/analyzedInstructions?stepBreakdown=true"
//        let test_url = URL(string: urlString)
//        guard test_url != nil else { return }
//
//        var request = URLRequest(url: test_url!, cachePolicy: .useProtocolCachePolicy,
//                                                 timeoutInterval: 10.0)
//
//        let header = ["X-RapidAPI-Key": "20a6998a90msh0516f8821cc4954p199178jsnf78c2b51a123",
//                                      "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"]
//
//        request.allHTTPHeaderFields = header
//        request.httpMethod = "GET"
//
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request) { (data, response, error) in
//            if error == nil && data != nil {
//                let decoder = JSONDecoder()
//
//                do {
//                    let instructions = try JSONDecoder().decode([Instructions].self, from: data!)
//                    print("result: \(instructions)")
//                }
//                catch {
//                    print("Error in JSON parsing")
//                }
//
//            }
//        }
//
//        dataTask.resume()
        
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
                        completed()
                        //self.collectionView.reloadData()
                        print("results: \(self.instructionData)")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.lbTitle.text = "No data"
                        // add alert
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
        
        cell.stepNo.text = "Step \(instructionData[indexPath.row].number)"
        cell.step.text = "\(instructionData[indexPath.row].step)"

//        for item in self.instructionData[indexPath.row].steps {
//            cell.stepNo.text = "Step \(item.number)"
//            cell.step.text = "\(item.step)"
//        }
        
//        cell.stepNo.text = "Step \(String(instructionData[(indexPath.row)].steps[indexPath.row].number))"
//        print("Number: \(String(instructionData[indexPath.row].steps[indexPath.row].number))")
//        cell.step.text = "Equipment: \(instructionData[indexPath.row].steps[indexPath.row].equipment[indexPath.row].localizedName)\n\n\(instructionData[indexPath.row].steps[indexPath.row].step)"
        cell.step.isEditable = false
        cell.step.backgroundColor = myYellow
        //print("step: \(instructionData[indexPath.row].steps[indexPath.row].step) \n \(instructionData[indexPath.row].steps[indexPath.row].equipment[0].localizedName)")
        
        return cell
    }

}

//extension detailInstructionsVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return instructionData.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //let model = self.instructionData[indexPath.section].steps[indexPath.row]
//        let model = self.instructionData[indexPath.row].steps[indexPath.row]
//        print("row: \(indexPath.row), section: \(indexPath.section), item: \(indexPath.item), count: \(indexPath.count)")
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "instCell", for: indexPath) as! instCell
//
//        cell.stepNo.text = "Name: \(model.step)"
//        print("step: \(model.step)")
//        cell.step.text = "Inst: \(model.number)"
//        print("Step No. \(model.number)")
//
//        return cell
//    }
//}


