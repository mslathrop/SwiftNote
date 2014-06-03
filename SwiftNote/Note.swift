//
//  Note.swift
//  SwiftNote
//
//  Created by AppBrew LLC (appbrewllc.com) on 6/3/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

import CoreData
import UIKit

class Note: NSManagedObject {
    @NSManaged var body: NSString
    @NSManaged var createdAt: NSDate
    @NSManaged var entityId: NSString
    @NSManaged var modifiedAt: NSDate
    @NSManaged var title: NSString
}
