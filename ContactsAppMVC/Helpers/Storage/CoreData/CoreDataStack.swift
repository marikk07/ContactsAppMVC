//
//  CoreDataStack.swift
//  WeatherApp
//
//  Created by Maryan Pasichniak on 10/4/18.
//  Copyright © 2018 Maryan Pasichniak. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack: StorageProtocol {
    
    static let shared = CoreDataStack()
    
    init() {
        checkIfLocalJsonFileLoadedAlready()
    }
    
    //MARK: - Storage Protocol
    func saveContact(contact: Contact) {
        
        self.saveContext(contact.managedObjectContext)
    }
    
    func deleteContact(contact: Contact) {
        if let context = contact.managedObjectContext {
            context.delete(contact)
            self.saveContext(context)
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Contact")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext (_ _context: NSManagedObjectContext?) {
        let context = _context ?? persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - Fetch Local JSON Contacts
    
    private func checkIfLocalJsonFileLoadedAlready() {
        let request = NSFetchRequest<Contact>(entityName: "Contact")
        let sort = NSSortDescriptor(key: "firstName", ascending: false)
        request.sortDescriptors = [sort]
        let newContext =  self.persistentContainer.newBackgroundContext()
        do {
            let results =  try newContext.fetch(request)
            if results.isEmpty {
                fetchLocalJsonContacts()
            }
        } catch {
            debugPrint("Error while loading objects")
        }
    }
    
    private func fetchLocalJsonContacts() {
        if let path  = Bundle.main.path(forResource: "data", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url, options: .alwaysMapped)
                
                let context = persistentContainer.newBackgroundContext()
                
                let decoder = JSONDecoder()
                decoder.userInfo[CodingUserInfoKey.context!] = context
                _ = try decoder.decode([Contact].self, from: data)
                self.saveContext(context)
            }
            catch {
                debugPrint("Error with local json file")
            }
        }
        
    }
    
}


