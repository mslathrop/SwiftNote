//
//  TodayViewController.swift
//  SwiftNoteTodayWidget
//
//  Created by Matthew Lathrop on 6/6/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

import CoreData
import UIKit
import NotificationCenter

class TodayViewController: UITableViewController, NCWidgetProviding {
    
    init(coder aDecoder: NSCoder!)  {
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.clearColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encoutered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    // MARK - core data methods
    
    var managedObjectContext: NSManagedObjectContext {
    if !_managedObjectContext {
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
    if !_managedObjectModel {
        let modelURL = NSBundle.mainBundle().URLForResource("SwiftNote", withExtension: "momd")
        _managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)
        }
        return _managedObjectModel!
    }
    var _managedObjectModel: NSManagedObjectModel? = nil
    
    // Returns the persistent store coordinator for the application.
    // If the coordinator doesn't already exist, it is created and the application's store added to it.
    var persistentStoreCoordinator: NSPersistentStoreCoordinator {
    if !_persistentStoreCoordinator {
        let storeURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SwiftNote.sqlite")
        var error: NSError? = nil
        
        _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        var currentiCloudtoken = NSFileManager.defaultManager().ubiquityIdentityToken
        
        var options: NSDictionary? = nil
        if (currentiCloudtoken) {
            let defaultCenter = NSNotificationCenter.defaultCenter()
            
            defaultCenter.addObserver(self, selector: "storesWillChange:", name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: _persistentStoreCoordinator)
            
            defaultCenter.addObserver(self, selector: "storesDidChange:", name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: _persistentStoreCoordinator)
            
            defaultCenter.addObserver(self, selector: "persistentStoreDidImportUbiquitousContentChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: _persistentStoreCoordinator)
            
            /*
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
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        }
        return _persistentStoreCoordinator!
    }
    var _persistentStoreCoordinator: NSPersistentStoreCoordinator? = nil
    
    // #pragma mark - Application's Documents directory
    
    // Returns the URL to the application's Documents directory.
    var applicationDocumentsDirectory: NSURL {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex-1] as NSURL
    }
    
}
