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
    var bindTodoViewModelToController: (()->Void)?
    
     func fetchOnlineTasks() {
        Task {@MainActor in
            let todoNetworkService = TodoNetworkService()
            do {
                let todos = try await todoNetworkService.fetchTodos()
                self.onlineTasks = todos
                bindTodoViewModelToController?()
            } catch {}
        }
    }
}
