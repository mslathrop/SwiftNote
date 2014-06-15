//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by Kai Engelhardt on 10.06.14.
//  Copyright (c) 2014 Kai Engelhardt. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UITableViewController, NCWidgetProviding {
    
    // MARK: variables
    let kMaxCellCount = 2
    let kCellHeight = 70.0
    let coreDataProvider = CoreDataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        var ret = 5
        
        // set the content size
        var height = CGFloat(ret) * kCellHeight
        self.preferredContentSize = CGSizeMake(320.0, height)
        
        return ret
    }
    
    override func tableView(_: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReuseIdentifierTodayTableViewCell, forIndexPath: indexPath) as TodayTableViewCell
        
        // set cell defaults
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        
        cell.titleLabel.text = "Title"
        cell.bodyLabel.text = "Body"
        return cell
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat  {
        return kCellHeight
    }
    
    /*
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
    let entity = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
    let note = Note.noteFromNoteEntity(entity)
    note.deleteInManagedObjectContext((UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext)
    (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    }
    */

    
}
