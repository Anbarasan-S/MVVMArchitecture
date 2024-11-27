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
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    //MARK: PRIVATE METHODS
    private func viewConfig() {
        addSubview(titleLabel)
        backgroundColor = .white
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    //MARK: PUBLIC METHODS
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    //MARK: INITIALIZERS
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
