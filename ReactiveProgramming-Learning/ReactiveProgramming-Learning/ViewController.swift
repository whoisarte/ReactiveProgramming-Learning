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

class CustomTableCell: UITableViewCell {
    
    private let button: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("Botón", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    //This
    let action = PassthroughSubject<String, Never>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(button)
        self.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 10, y: 10, width: contentView.frame.size.width - 20, height: contentView.frame.size.height - 6 )
    }
    
    @objc func didTapButton() {
        action.send("Button was tapped...")
    }
    
}

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

