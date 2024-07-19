//
//  PersistantStorage.swift
//  My Movie
//
//  Created by Ravindra Gaikwad on 03/07/24.
//

import Foundation
import CoreData

final class PersistantStorage {
    // MARK: - Core Data stack
    
    private init() {}
    static let shared = PersistantStorage()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "My_Movie")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
