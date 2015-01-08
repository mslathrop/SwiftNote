//
//  CoreDataProvider.swift
//  SwiftNote
//
//  Created by Matthew Lathrop on 6/11/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

import CoreData

class CoreDataProvider: NSObject {
    
    var applicationDocumentsDirectory: NSURL! = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex-1] as NSURL
        }()
    
    func saveContext () {
        var error: NSError? = nil
        let managedObjectContext = self.managedObjectContext
        if managedObjectContext.save(&error) {
            if managedObjectContext.hasChanges && !managedObjectContext.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }
    
    // #pragma mark - Core Data stack
    
    // Returns the managed object context for the application.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    var managedObjectContext: NSManagedObjectContext {
    if _managedObjectContext == nil {
        _managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        _managedObjectContext!.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        _managedObjectContext!.persistentStoreCoordinator = self.persistentStoreCoordinator
        }
        return _managedObjectContext!
    }
    var _managedObjectContext: NSManagedObjectContext? = nil
    
    // Returns the managed object model for the application.
    // If the model doesn't already exist, it is created from the application's model.
    var managedObjectModel: NSManagedObjectModel {
    if _managedObjectModel == nil {
        let modelURL = NSBundle.mainBundle().URLForResource("SwiftNote", withExtension: "momd")
        _managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL!)
        }
        return _managedObjectModel!
    }
    var _managedObjectModel: NSManagedObjectModel? = nil
    
    // Returns the persistent store coordinator for the application.
    // If the coordinator doesn't already exist, it is created and the application's store added to it.
    var persistentStoreCoordinator: NSPersistentStoreCoordinator {
    if _persistentStoreCoordinator == nil {
        
        // store url should point to the shared container
        var storeURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(kAppGroupIdentifier)
        storeURL = storeURL?.URLByAppendingPathComponent("SwiftNote.sqlite")
        
        //store url if you don't want to make a shared container.
        //var storeURL = applicationDocumentsDirectory.URLByAppendingPathComponent("SwiftNote.sqlite")
        
        var error: NSError? = nil
        
        _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        var currentiCloudtoken = NSFileManager.defaultManager().ubiquityIdentityToken
        
        var options: NSDictionary? = nil
        if (currentiCloudtoken != nil) {
            let defaultCenter = NSNotificationCenter.defaultCenter()
            
            /*
            defaultCenter.addObserver(self, selector: "storesWillChange:", name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: _persistentStoreCoordinator)
            
            defaultCenter.addObserver(self, selector: "storesDidChange:", name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: _persistentStoreCoordinator)
            
            defaultCenter.addObserver(self, selector: "persistentStoreDidImportUbiquitousContentChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: _persistentStoreCoordinator)
            
            defaultCenter.addObserverForName(nil, object: nil, queue: nil, usingBlock: { (notification: NSNotification!) in
            println("$$$$$$$$$$\n\(notification.description)\n")
            })
            */
            
            options = [ NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true, NSPersistentStoreUbiquitousContentNameKey: "SwiftNoteiCloudStore" ]
        }
        else {
            options = [ NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true ]
        }
        
        if _persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error) == nil {
            /*
            Replace this implementation with code to handle the error appropriately.
            
            abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            
            Typical reasons for an error here include:
            * The persistent store is not accessible;
            * The schema for the persistent store is incompatible with current managed object model.
            Check the error message to determine what the actual problem was.
            
            
            If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
            
            If you encounter schema incompatibility errors during development, you can reduce their frequency by:
            * Simply deleting the existing store:
            NSFileManager.defaultManager().removeItemAtURL(storeURL, error: nil)
            
            * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
            [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true}
            
            Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
            
            */
            println("Unresolved error \(error), \(error?.description)")
            abort()
        }
        }
        return _persistentStoreCoordinator!
    }
    var _persistentStoreCoordinator: NSPersistentStoreCoordinator? = nil
    
    // MARK - iCloud handling
    
    func persistentStoreDidImportUbiquitousContentChanges(notification: NSNotification!) {
        println("== persistentStoreDidImportUbiquitousContentChanges ==\n")
        println(notification.description)
        
        let context = self.managedObjectContext
        
        context.performBlock(({
            context.mergeChangesFromContextDidSaveNotification(notification)
            }))
    }
    
    func storesWillChange(notification: NSNotification!) {
        println("== storesWillChange ==\n")
        println(notification.description)
        
        let context = self.managedObjectContext
        
        context.performBlockAndWait(({
            var error: NSError? = nil
            
            if context.hasChanges {
                let success = context.save(&error)
                
                if (success == false && error != nil) {
                    println(error!.localizedDescription)
                }
            }
            
            context.reset()
            }))
    }
    
    func storesDidChange(notification: NSNotification!) {
        println("== storesDidChange ==\n")
        println(notification.description)
        
        //TODO
    }
    
    //TODO: create coreDataDelegate protocl

}
