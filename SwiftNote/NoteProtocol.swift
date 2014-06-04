//
//  NoteProtocol.swift
//  SwiftNote
//
//  Created by Matthew Lathrop on 6/4/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

import CoreData
import Foundation

protocol NoteProtocol {
    var body: NSString? { get set }
    var createdAt: NSDate? { get set }
    var entityId: NSString? { get set }
    var modifiedAt: NSDate? { get set }
    var title: NSString? { get set }
    
    class func insertNewNote() -> NoteProtocol
    class func note(#managedObject: NSManagedObject) -> NoteProtocol
    func save(#title: String, body: String)
}
