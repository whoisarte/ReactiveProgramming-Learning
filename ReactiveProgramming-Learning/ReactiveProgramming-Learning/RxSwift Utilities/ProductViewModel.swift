//
//  ProductViewModel.swift
//  ReactiveProgramming-Learning
//
//  Created by Artemio Pánuco on 20/07/24.
//

import Foundation
import RxSwift

struct Product {
    let imageName: String
    let title: String
}


struct ProductViewModel {
    var items = PublishSubject<[Product]>()
    
    func fetchItems() {
        let products = [
            Product(imageName: "house", title: "Home"),
            Product(imageName: "gear", title: "Settings"),
            Product(imageName: "person.circle", title: "Profile"),
            Product(imageName: "airplane", title: "Flights"),
            Product(imageName: "bell", title: "Activity")
            ]
        items.onNext(products)
        items.onCompleted()
    }
}
