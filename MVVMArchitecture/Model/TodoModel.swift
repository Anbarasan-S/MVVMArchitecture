//
//  TodoModel.swift
//  MVVMArchitecture
//
//  Created by temp-17476 on 12/11/24.
//

import Foundation

struct TodoModel: Codable {
    var id: UUID = UUID()
    let title: String
    let completed: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case title
        case completed
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.completed = try container.decode(Bool.self, forKey: .completed)
    }
    
    init(id:UUID, title: String, completed: Bool) {
        self.title = title
        self.completed = completed
        self.id = id
    }
}
