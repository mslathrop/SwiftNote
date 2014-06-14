//
//  TodayViewController.swift
//  SwiftNoteTodayWidget
//
//  Created by Matthew Lathrop on 6/6/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

import CoreData
import NotificationCenter
import UIKit

class TodayViewController: UITableViewController, NCWidgetProviding, NSFetchedResultsControllerDelegate {
    
    // MARK: variables
    let kMaxCellCount = 2
    
    var coreDataProvider: CoreDataProvider
    
    var fetchedResultsController: NSFetchedResultsController {
    if !_fetchedResultsController {
        // set up fetch request
        var fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName(kEntityNameNoteEntity, inManagedObjectContext: self.coreDataProvider.managedObjectContext)
        
        // sort by last updated
        var sortDescriptor = NSSortDescriptor(key: "modifiedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = kMaxCellCount
        
        _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataProvider.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        _fetchedResultsController!.delegate = self
        }
        
        return _fetchedResultsController!;
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    // MARK: view handling
    
    init(coder aDecoder: NSCoder!)  {
        self.coreDataProvider = CoreDataProvider()
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.clearColor()
        
        self.fetchedResultsController.performFetch(nil)
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    // MARK: Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections[section] as NSFetchedResultsSectionInfo
        
        var numRows = sectionInfo.numberOfObjects
        if (numRows > kMaxCellCount) {
            numRows = kMaxCellCount
        }
        
        return 5
    }
    
    override func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReuseIdentifierTodayTableViewCell, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = "whyyyy"
        return cell
        
        //let entity = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
        //let note = Note.noteFromNoteEntity(entity)
        //cell.configure(note: note, indexPath: indexPath)
        //return cell
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat  {
        return 70
    }
    
    /*
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        let entity = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
        let note = Note.noteFromNoteEntity(entity)
        note.deleteInManagedObjectContext((UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext)
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    }
    */
    
    // MARK: - fetched results controller delegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case NSFetchedResultsChangeInsert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case NSFetchedResultsChangeDelete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {
        switch type {
        case NSFetchedResultsChangeInsert:
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        case NSFetchedResultsChangeDelete:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case NSFetchedResultsChangeUpdate:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as TodayTableViewCell
            let note = self.fetchedResultsController.sections[indexPath.section][indexPath.row] as Note
            cell.configure(note: note, indexPath: indexPath)
        case NSFetchedResultsChangeMove:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}
