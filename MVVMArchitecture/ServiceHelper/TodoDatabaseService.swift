//
//  TodoDatabaseService.swift
//  MVVMArchitecture
//
//  Created by Anbarasan S on 21/11/24.
//

import Foundation

public enum DatabaseError: Error {
    case saveFailed
    case deleteFailed
}

class TodoDatabaseService: DatabaseService {
    
    //MARK: Save Method
     func save(todoModels: [TodoModel]) throws {
        let privateContext = newBackgroundContext(name: "TodoDBMultipleModelSave")
        try privateContext.performAndWait {
            // map the value from the model to the managed object
            for todoModel in todoModels {
                let todoMO = TodoMO(context: privateContext)
                todoMO.title = todoModel.title
                todoMO.completed = todoModel.completed
                todoMO.id = todoModel.id
                todoMO.createdTime = Date.now
            }
            
            // save the value
            if saveInContext(context: privateContext) == false {
                throw DatabaseError.saveFailed
            }
        }
    }
    
    func save(todoModel: TodoModel) throws {
        let privateContext = newBackgroundContext(name: "TodoDBModelSave")
        try privateContext.performAndWait {
            let todoMO = TodoMO(context: privateContext)
            todoMO.title = todoModel.title
            todoMO.completed = todoModel.completed
            todoMO.id = todoModel.id
            todoMO.createdTime = Date.now
            
            if saveInContext(context: privateContext) == false {
                throw DatabaseError.saveFailed
            }
        }
    }
    
    //MARK: Delete Method
    func delete(todoModel: TodoModel) throws {
        let privateContext = newBackgroundContext()
        try privateContext.performAndWait {
            let todoModelId = todoModel.id
            let predicate = NSPredicate(format: "id == %@", todoModelId as CVarArg)
            delete(entityName: "TodoMO", predicate: predicate, context: privateContext)
            
            if saveInContext(context: privateContext) == false {
                throw DatabaseError.deleteFailed
            }
        }
    }
    
    func delete(todoModels: [TodoModel]) throws {
        let privateContext = newBackgroundContext()
        try privateContext.performAndWait {
            for todoModel in todoModels {
                
                let todoModelId = todoModel.id
                let predicate = NSPredicate(format: "id == %@", todoModelId as CVarArg)
                delete(entityName: "TodoMO", predicate: predicate, context: privateContext)
            }
            
            if saveInContext(context: privateContext) == false {
                throw DatabaseError.deleteFailed
            }
        }
        
    }
    
    func delete(todoModelId: UUID) throws {
        let privateContext = newBackgroundContext()
        try privateContext.performAndWait {
            let predicate = NSPredicate(format: "id == %@", todoModelId as CVarArg)
            delete(entityName: "TodoMO", predicate: predicate, context: privateContext)
            
            if saveInContext(context: privateContext) == false {
                throw DatabaseError.deleteFailed
            }
        }
    }
    
    func fetch() -> [TodoModel] {
        var todoModels = [TodoModel]()
        let context = newBackgroundContext()
        if let todoMOs = fetch(withEntityName: "TodoMO", context: context) as? [TodoMO] {
            todoMOs.forEach {todoMO in
                todoModels.append(TodoModel(id: todoMO.id!, title: todoMO.title!, completed: todoMO.completed))
            }
        }
        
        return todoModels
    }
    
    func fetch(with id: Int64) -> TodoModel {
        let context = newBackgroundContext()
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let todoMOs = fetch(withEntityName: "TodoMO", predicate: predicate, context: context) as! [TodoMO]
        
        return TodoModel(id: todoMOs[0].id!, title: todoMOs[0].title!, completed: todoMOs[0].completed)
    }
    
}
