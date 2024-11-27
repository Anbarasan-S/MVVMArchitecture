//
//  TodoViewModel.swift
//  MVVMArchitecture
//
//  Created by temp-17476 on 13/11/24.
//

import Foundation

class TodoViewModel {
    //MARK: PUBLIC METHODS
    var onlineTasks = [TodoModel]()
    var offlineTasks = [TodoModel]()
    var bindTodoViewModelToController: (()->Void)?
    var bindErrorToController: ((TodoError)->Void)?
    
    func fetchOnlineTasks() {
        Task {@MainActor in
            let todoNetworkService = TodoNetworkService()
            do {
                let todos = try await todoNetworkService.fetchTodos()
                self.onlineTasks = todos
                bindTodoViewModelToController?()
            } catch {
                if let error = error as? URLError {
                       switch error.code {
                       case .notConnectedToInternet:
                           bindErrorToController?(.noInternet)
                       case .timedOut:
                           bindErrorToController?(.requestTimeout)
                       case .networkConnectionLost:
                           bindErrorToController?(.networkLost)
                       default:
                           bindErrorToController?(.unknownError)
                       }
                   }
            }
        }
    }
    
    func fetchOfflineTasks() {
        Task {@MainActor in
            let todoDbService = TodoDatabaseService()
            let todoModels = todoDbService.fetch()
            self.offlineTasks = todoModels
            bindTodoViewModelToController?()
        }
    }
    
    func saveTodo(title: String, completed: Bool) {
        let todoDatabaseService = TodoDatabaseService()
        let todoModel = TodoModel(id: UUID(), title: title, completed: completed)
        do {
            try todoDatabaseService.save(todoModel: todoModel)
            fetchOfflineTasks()
        } catch {
            debugPrint("Error in saving todo \(error.localizedDescription)")
        }
    }
}
