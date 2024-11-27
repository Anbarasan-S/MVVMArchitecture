//
//  DatabaseService.swift
//  MVVMArchitecture
//
//  Created by Anbarasan S on 21/11/24.
//

import Foundation
import UIKit
import CoreData


public class DatabaseService {
    
    
    //MARK: PUBLIC PROPERTIES
    // This should be created in a main thread
    static var persistentContainer: NSPersistentContainer = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer
    }()
    
    //MARK: PUBLIC METHODS
    public static func initialise() {
        _ = persistentContainer
    }
    
    @discardableResult
    public func saveInContext(context: NSManagedObjectContext) -> Bool {

        var isSuccess = true
        context.performAndWait {
            if let persistentStores = context.persistentStoreCoordinator?.persistentStores.count, persistentStores > 0 {
                do {
                    try context.save()
                } catch {
                    debugPrint("Failed to save \(error)")
                    isSuccess = false
                }
            } else {
                isSuccess = false
            }
        }
        return isSuccess
    }
    
    
    public func fetch(withEntityName entityName: String, fetchOffset: Int? = nil, fetchLimit: Int? = nil, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, context: NSManagedObjectContext) -> [Any] {

        var result = [Any]()
        context.performAndWait {

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sortDescriptors

            if let fetchLimit = fetchLimit {
                fetchRequest.fetchLimit = fetchLimit
            }
            if let fetchOffset = fetchOffset {
                fetchRequest.fetchOffset = fetchOffset
            }

            do {
                result = try context.fetch(fetchRequest)
            } catch {
                debugPrint("Failed to fetch data \(error)")
            }
        }

        return result
    }
    
    public func newBackgroundContext(name: String? = nil) -> NSManagedObjectContext {
        // Create a private queue context.
        /// - Tag: newBackgroundContext
        let backgroundContext = DatabaseService.persistentContainer.newBackgroundContext()
        backgroundContext.name = name
        backgroundContext.shouldDeleteInaccessibleFaults = true
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.automaticallyMergesChangesFromParent = true

        return backgroundContext
    }
    
    
    public func delete(entityName: String, predicate: NSPredicate? = nil, context: NSManagedObjectContext) {
        
        let result: [Any] = fetch(withEntityName: entityName, predicate: predicate, context: context)

        for object in result {
            context.performAndWait {
                context.delete(object as! NSManagedObject)
            }
        }
    }
    
}
