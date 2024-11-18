//
//  TodoViewController.swift
//  MVVMArchitecture
//
//  Created by temp-17476 on 12/11/24.
//

import UIKit
import SwiftUI

class TodoViewController: UIViewController {
    
    //MARK: PRIVATE UI PROPERTIES
    private lazy var collectionView = {
        let aView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        aView.translatesAutoresizingMaskIntoConstraints = false
        aView.contentInset = .zero
        return aView
    }()
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>?
    private var dataStore = [String: TodoModel]()
    private var todoModels = [Section: [TodoModel]]()
    
    //MARK: PRIVATE DATA PROPERTIES
    private enum Section {
        case offline
        case online
        
        var displayString: String{
            switch self {
            case .offline:
                return "Offline Tasks"
            case .online:
                return "Online Tasks"
            }
        }
    }
    private var todoViewModel: TodoViewModel = TodoViewModel()
    
    
    //MARK: LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionViewCells()
        viewConfig()
        configureDataSource()
        todoViewModel.bindTodoViewModelToController = todoViewModelCompletionHandler
        todoViewModel.fetchOnlineTasks()
    }
    
    //MARK: PRIVATE UI METHOD
    private func viewConfig() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout{[unowned self] section, layoutEnvironment -> NSCollectionLayoutSection? in
            let listConfig = getListConfiguration(for: section)
            let section = NSCollectionLayoutSection.list(using: listConfig, layoutEnvironment: layoutEnvironment)
            return section
        }
        return layout
    }
    
    private func getListConfiguration(for section: Int) -> UICollectionLayoutListConfiguration {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        if let sectionIdentifier = dataSource?.sectionIdentifier(for: section) {
            if let itemIdentifiers = dataSource?.snapshot().itemIdentifiers(inSection: sectionIdentifier), itemIdentifiers.isEmpty == false {
                configuration.headerMode = .firstItemInSection
            }
        }
        return configuration
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {[unowned self](collectionView,indexPath,itemIdentifier) -> UICollectionViewCell in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCollectionViewListCell.identifier, for: indexPath) as? TodoCollectionViewListCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
            }
            if let todoModel = dataStore[itemIdentifier] {
                cell.setData(title: todoModel.title, isCompleted: todoModel.completed, isFirstItem: indexPath.row == 0)
            }
            return cell
        }
        
        dataSource?.supplementaryViewProvider = {[unowned self] (collectionView, kind, indexPath) -> UICollectionReusableView in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as? HeaderCollectionReusableView else{
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
                return headerView
            }
            if let sectionName = dataSource?.snapshot().sectionIdentifiers[indexPath.section].displayString {
                headerView.setTitle(sectionName)
            }
            return headerView
        }
    }
    
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.offline, .online])
        if let offlineTodoModels = todoModels[Section.offline] {
            let ids = offlineTodoModels.map {
                return "\($0.id)"
            }
            snapshot.appendItems(ids, toSection: .offline)
        }
        
        if let onlineTodoModels = todoModels[Section.online] {
            let ids = onlineTodoModels.map{
                return "\($0.id)"
            }
            snapshot.appendItems(ids, toSection: .online)
        }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func registerCollectionViewCells() {
        collectionView.register(TodoCollectionViewListCell.self, forCellWithReuseIdentifier: TodoCollectionViewListCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView")
    }
    
    //MARK: PRIVATE DATA METHODS
    private func todoViewModelCompletionHandler() {
        todoModels[.online] = todoViewModel.onlineTasks
        todoModels[.online]?.forEach{
            dataStore["\($0.id)"] = $0
        }
        applySnapshot()
    }
    
}
