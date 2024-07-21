//
//  ViewController.swift
//  ReactiveProgramming-Learning
//
//  Created by Artemio Pánuco on 19/07/24.
//

import Combine
import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CustomTableCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var observers: Set<AnyCancellable> = []
    private var languages = [String]()
    
    //RxSwift dependencies
    private var viewModel = ProductViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.bindTableWithRxSwift()
    }
    
    func bindTableWithCombine() {
        APIManager.shared.fecthLanguages()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Languages obtention finished")
                case .failure(let error):
                    print("Error retrieving languages: \(error)")
                }
            }, receiveValue: { [weak self] languages in
                self?.languages = languages
                self?.tableView.reloadData()
            })
            .store(in: &observers)
    }
    
    func bindTableWithRxSwift() {
        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: CustomTableCell.self)) { row, product, cell in
            cell.textLabel?.text = product.title
            cell.imageView?.image = UIImage(systemName: product.imageName)
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Product.self).bind { product in
            print("Product selected: \(product.title)")
        }
        .disposed(by: disposeBag)
        
        viewModel.fetchItems()
    }
    
    func configureTableView() {
        self.view.addSubview(self.tableView)
        self.tableView.frame = self.view.bounds
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
    }
}
//
////Tis delegates only works for Commbine
//extension ViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.languages.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableCell {
//            cell.textLabel?.text = self.languages[indexPath.row]
//            cell.action.sink { value in
//                print(value)
//            }.store(in: &observers)
//            return cell
//        }
//        fatalError("Error dequeuing table cell.")
//    }
//}

