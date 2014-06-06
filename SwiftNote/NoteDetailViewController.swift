//
//  NoteDetailViewController.swift
//  SwiftNote
//
//  Created by Matthew Lathrop on 6/3/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

import CoreData
import UIKit

class NoteDetailViewController: UIViewController {
    
    // MARK: properties
    @IBOutlet var titleTextField: UITextField
    
    @IBOutlet var bodyTextView: UITextView
    
    @IBOutlet var tapToEditLabel: UILabel
    
    var note: NoteProtocol?
    
    // MARK: methods
    
    init(coder aDecoder: NSCoder!)  {
        super.init(coder: aDecoder)
    }
    
    // MARK: view methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool)  {
        super.viewWillAppear(animated)
        
        //TODO: observe keyboard notifications
    }
    
    override func viewWillDisappear(animated: Bool)  {
        super.viewWillDisappear(animated)
        
        if !note {
            note = Note.insertNewNote()
        }
        
        note?.update(title: "test", body: "still testing")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    }
    
}
