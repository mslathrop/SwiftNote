//
//  NotesTableViewController.swift
//  SwiftNote
//
//  Created by AppBrew LLC (appbrewllc.com) on 6/3/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

import CoreData
import UIKit

class NotesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext {
    get {
        if !(_managedObjectContext != nil) {
            _managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        }
        
        return _managedObjectContext!
    }
    }
    var _managedObjectContext: NSManagedObjectContext? = nil
    
    var fetchedResultsController: NSFetchedResultsController {
    get {
        if !(_fetchedResultsController != nil) {
            // set up fetch request
            var fetchRequest = NSFetchRequest()
            fetchRequest.entity = NSEntityDescription.entityForName(kEntityNameNoteEntity, inManagedObjectContext: (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext)
            
            // sort by last updated
            var sortDescriptor = NSSortDescriptor(key: "modifiedAt", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.fetchBatchSize = 20
            
            _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext, sectionNameKeyPath: nil, cacheName: "allNotesCache")
            _fetchedResultsController!.delegate = self
        }
        
        return _fetchedResultsController!;
    }
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchedResultsController.performFetch(nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)  {
        if (segue.identifier == kSegueIdentifierNotesTableToNoteDetailEdit) {
            let entity = self.fetchedResultsController.objectAtIndexPath(self.tableView.indexPathForSelectedRow()!) as NSManagedObject
            let note = Note.noteFromNoteEntity(entity)
            let viewController = segue.destinationViewController as NoteDetailViewController
            viewController.note = note
        }
    }
    
    // #pragma mark - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return self.fetchedResultsController.sections!.count
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections?[section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReuseIdentifierNotesTableViewCell, forIndexPath: indexPath) as NotesTableViewCell
        let entity = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
        let note = Note.noteFromNoteEntity(entity)
        cell.configure(note: note, indexPath: indexPath)
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat  {
        return 70
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let entity = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
        let note = Note.noteFromNoteEntity(entity)
        note.deleteInManagedObjectContext((UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext)
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    }
    
    // MARK: - fetched results controller delegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as NotesTableViewCell
            let note = self.fetchedResultsController.sections?[indexPath.section][indexPath.row] as Note
            cell.configure(note: note, indexPath: indexPath)
        case .Move:
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
