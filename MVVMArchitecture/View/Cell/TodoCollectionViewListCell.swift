//
//  TodoCollectionViewListCell.swift
//  MVVMArchitecture
//
//  Created by temp-17476 on 12/11/24.
//

import UIKit

class TodoCollectionViewListCell: UICollectionViewListCell {
    
    //MARK: STATIC PROPERTIES
    static let identifier = "TodoCollectionViewListCell"
    //MARK: PRIVATE PROPERTIES
    private lazy var label: UILabel = {
      let aLabel = UILabel()
        aLabel.translatesAutoresizingMaskIntoConstraints = false
        return aLabel
    }()
    
    //MARK: INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: PRIVATE METHODS
    private func viewConfig() {
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: PaddingConstants.TodoCell.vertical),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: PaddingConstants.TodoCell.horizontal),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -PaddingConstants.TodoCell.horizontal),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -PaddingConstants.TodoCell.vertical)
        ])
    }
    
    //MARK: PUBLIC METHODS
    func setData(title: String, isCompleted: Bool) {
        label.text = title
    }
}
