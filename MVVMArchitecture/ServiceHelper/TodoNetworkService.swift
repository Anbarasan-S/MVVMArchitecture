//
//  TodoNetworkService.swift
//  MVVMArchitecture
//
//  Created by temp-17476 on 13/11/24.
//

import Foundation

struct TodoNetworkService {
    public func fetchTodos() async throws -> [TodoModel] {
        let urlSession = URLSession.shared
        if let url = URL(string: NetworkConstants.getTodoUrl) {
            let urlRequest = URLRequest(url: url)
            let result = try await urlSession.data(for: urlRequest)
            let todoModels = try JSONDecoder().decode([TodoModel].self, from: result.0)
            return todoModels
        } else {
            throw TodoError.unknownError
        }
    }
}
