//
//  detailInstructionsVC.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 12/19/22.
//

import UIKit
import Kingfisher

class detailInstructionsVC: UIViewController {
    
    var data = [Instructions]()
    
    private var instructionData = [Instructions]()
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var id = ""
    var foodImgUrl = ""
    var name = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor.red
        
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
            self.tableView.reloadData()
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
                self.instructionData = try JSONDecoder().decode([Instructions].self, from: data)
                
                if self.instructionData.count > 0 {
                    DispatchQueue.main.async {
                        completed()
                        self.tableView.reloadData()
                        print("results: \(self.instructionData)")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.lbTitle.text = "No data"
                    }
                }
            }
            catch {
                let error = error
                print(String(describing: error))
            }
        }.resume()
    }

}

extension detailInstructionsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "instCell", for: indexPath) as! instCell

        cell.stepNo.text = "Hiiii"//"Name: \(data[indexPath.row].name)"
        cell.step.text = "Inst: \(data[indexPath.row].steps)"
        
        return cell
    }
}


