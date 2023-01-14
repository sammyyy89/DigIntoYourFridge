import UIKit
import FirebaseAuth
import Foundation
import RealmSwift

class instructionsVC: UIViewController {
    
    var selectedData: [String]?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lbTitle: UILabel!
    private var instructionData = [Instructions]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func fetchData(completed: @escaping () -> ()) {
        
        let url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/226198/analyzedInstructions?stepBreakdown=true")
        
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
                    }
                } else {
                    DispatchQueue.main.async {
                        self.lbTitle.text = "None"
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
