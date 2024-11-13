//
//  HeaderCollectionReusableView.swift
//  MVVMArchitecture
//
//  Created by temp-17476 on 13/11/24.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    //MARK: STATIC PROPERTIES
    static let identifier = "HeaderCollectionReusableView"
    //MARK: PRIVATE PROPERTIES
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: PRIVATE METHODS
    private func viewConfig() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    //MARK: PUBLIC METHODS
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
