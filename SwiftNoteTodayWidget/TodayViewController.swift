//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by Matthew Lathrop on 6/3/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

import CoreData
import NotificationCenter
import UIKit

class TodayViewController: UITableViewController, NCWidgetProviding, NSFetchedResultsControllerDelegate {
    
    // MARK: variables
    let kMaxCellCount = 3
    
    let kCellHeight = 70.0
    
    let coreDataProvider = CoreDataProvider()
    
    var fetchedResultsController: NSFetchedResultsController {
    if !(_fetchedResultsController != nil) {
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
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    // MARK: view handling
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchedResultsController.performFetch(nil)
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    // MARK: Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections?[section] as NSFetchedResultsSectionInfo
        
        var numRows = sectionInfo.numberOfObjects
        if (numRows > kMaxCellCount) {
            numRows = kMaxCellCount
        }
        
        // set the content size. subtract one because i don't want the last separator showing
        var height = CGFloat(numRows) * CGFloat(kCellHeight) - 1.0
        self.preferredContentSize = CGSizeMake(320.0, height)
        
        return numRows
    }
    
    override func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReuseIdentifierTodayTableViewCell, forIndexPath: indexPath) as TodayTableViewCell
        
        // set cell defaults
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        
        // configure the cell
        let entity = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
        let note = Note.noteFromNoteEntity(entity)
        cell.configure(note: note, indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(tableView: (UITableView!), heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat  {
        return CGFloat(kCellHeight)
    }
}
