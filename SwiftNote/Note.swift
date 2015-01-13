//
//  Note.swift
//  SwiftNote
//
//  Created by AppBrew LLC (appbrewllc.com) on 6/3/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

import CoreData
import UIKit

class Note: NoteProtocol {
    var noteEntity: NSManagedObject? = nil
    
    var body: NSString? {
    get {
        return self.noteEntity!.valueForKey("body") as NSString!
    }
    set {
        self.noteEntity!.setValue(newValue, forKey: "body")
    }
    }
    
    var createdAt: NSDate? {
    get {
        return self.noteEntity!.valueForKey("createdAt") as NSDate!
    }
    set {
        self.noteEntity!.setValue(newValue, forKey: "createdAt")
    }
    }
    
    var entityId: NSString? {
    get {
        return self.noteEntity!.valueForKey("entityId") as NSString!
    }
    set {
        self.noteEntity!.setValue(newValue, forKey: "entityId")
    }
    }
    
    var modifiedAt: NSDate? {
    get {
        return self.noteEntity!.valueForKey("modifiedAt") as NSDate!
    }
    set {
        self.noteEntity!.setValue(newValue, forKey: "modifiedAt")
    }
    }

    var title: NSString? {
    get {
        return self.noteEntity!.valueForKey("title") as NSString!
    }
    set {
        self.noteEntity!.setValue(newValue, forKey: "title")
    }
    }
    
    class func insertNewNoteInManagedObjectContext(managedObjectContext: NSManagedObjectContext!) -> NoteProtocol {
        let note = Note()
        
        // create new entity
        note.noteEntity = NSEntityDescription.insertNewObjectForEntityForName(kEntityNameNoteEntity, inManagedObjectContext: managedObjectContext) as? NSManagedObject
        
        // set defaults
        note.createdAt = NSDate.init()
        note.modifiedAt = note.createdAt
        note.entityId =  NSUUID.init().UUIDString
        
        return note
    }
    
    class func noteFromNoteEntity(noteEntity: NSManagedObject) -> NoteProtocol {
        let note = Note()
        note.noteEntity = noteEntity
        return note
    }
    
    func update(#title: String, body: String)  {
        self.title = title;
        self.body = body;
        self.modifiedAt = NSDate.init()
    }
    
    func deleteInManagedObjectContext(managedObjectContext: NSManagedObjectContext!) {
        managedObjectContext.deleteObject(self.noteEntity!)
    }
}
