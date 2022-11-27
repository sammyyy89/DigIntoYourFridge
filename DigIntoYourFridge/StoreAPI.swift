//
//  StoreAPI.swift
//  DigIntoYourFridge
//
//  Created by Saemi An on 11/27/22.
//

import Foundation
import Combine

//class StoreAPI {
//    func recipes() -> Future<[Recipes], Never>{
//        return Future { promise in
//            let taskPublisher = URLSession.shared.dataTaskPublisher(for: URL(string: "https://spoonacular.com/cdn/ingredients_100x100/")!)
//            taskPublisher.map {
//                $0.data
//            }
//            .decode(type: [Recipes].self, decoder: JSONDecoder())
//            .sink { completion in
//                switch completion {
////                case finished:
////                    print("finished")
//                case .failure(_):
//                    promise(.success([Recipes]))
//                }
//            }
//        }
//    }
//}
