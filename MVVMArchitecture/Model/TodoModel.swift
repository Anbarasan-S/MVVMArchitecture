//
//  TodoModel.swift
//  MVVMArchitecture
//
//  Created by temp-17476 on 12/11/24.
//

import Foundation

struct TodoModel: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
