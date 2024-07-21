//
//  APIManager.swift
//  ReactiveProgramming-Learning
//
//  Created by Artemio Pánuco on 20/07/24.
//

import Combine
import RxSwift
import Foundation

class APIManager {
    static let shared = APIManager()
    
    private var disposeBag = DisposeBag()
    
    func fecthLanguages() -> Future<[String], Error> {
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                promise(.success(["Swift", "Golang", "C++", "Java", "Haskell" ,"Javascript", "Kotlin"]))
            }
        }
    }
    
    func fetchList() -> Single<[Product]> {
        return Single<[Product]>.create { single in
            let products = [
                Product(imageName: "house", title: "Home"),
                Product(imageName: "gear", title: "Settings"),
                Product(imageName: "person.circle", title: "Profile"),
                Product(imageName: "airplane", title: "Flights"),
                Product(imageName: "bell", title: "Activity")
            ]
            single(.success(products))
        }
    }
}
