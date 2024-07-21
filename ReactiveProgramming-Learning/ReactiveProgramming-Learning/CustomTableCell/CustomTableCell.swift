//
//  CustomTableCell.swift
//  ReactiveProgramming-Learning
//
//  Created by Artemio Pánuco on 20/07/24.
//

import UIKit
import Combine

class CustomTableCell: UITableViewCell {
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("Botón", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    //This is a subject of Combine, to listen tap events...
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

