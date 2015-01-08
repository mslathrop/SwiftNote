//
//  NoteDetailViewController.swift
//  SwiftNote
//
//  Created by Matthew Lathrop on 6/3/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

import CoreData
import UIKit

class NoteDetailViewController: UIViewController, UITextViewDelegate {
    
    // MARK: properties
    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet var bodyTextView: UITextView!
    
    @IBOutlet var tapToEditTextField: UITextField!
    
    var note: NoteProtocol?
    
    var saveNeeded: Bool
    
    // MARK: methods
    
    required init(coder aDecoder: NSCoder)  {
        saveNeeded = false
        
        super.init(coder: aDecoder)
    }
    
    // MARK: view methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fix default content inset
        self.bodyTextView?.contentInset = UIEdgeInsetsMake(-10,-4,0,-4)
        
        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool)  {
        super.viewWillAppear(animated)
        
        // observe keyboard events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool)  {
        super.viewWillDisappear(animated)
        
        self.updateNote()
        
        // remove keyboard observation
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object:nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.saveNeeded {
            (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
        }
    }
    
    func configureView() {
        if note != nil {
            // show the right bar button item
            //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "actionButtonTapped:")
            
            self.titleTextField.text = note?.title
            self.bodyTextView.text = note?.body
        }
        
        self.hideTapToEditLabelIfNeeded()
    }
    
    // MARK - textk view delegate methods
    
    func textViewDidBeginEditing(textView: UITextView!) {
        self.tapToEditTextField.hidden = true
    }
    
    func textViewDidEndEditing(textView: UITextView!) {
        self.tapToEditTextField.hidden = true
    }
    
    func textViewDidChange(textView: UITextView!) {
        self.showTextViewCaretPosition(textView)
    }
    
    func textViewDidChangeSelection(textView: UITextView!) {
        self.showTextViewCaretPosition(textView)
    }
    
    // MARK - keyboard notifications
    
    func keyboardWillShow(notification: NSNotification) {

        let frameValue = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
        let keyboardFrame = frameValue.CGRectValue()
        let animationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as NSNumber
        
        let isPortrait = UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)
        let keyboardHeight = isPortrait ? keyboardFrame.size.height : keyboardFrame.size.width
        
        var contentInset = self.bodyTextView.contentInset
        contentInset.bottom = keyboardHeight
        
        var scrollIndicatorInsets = self.bodyTextView.scrollIndicatorInsets
        scrollIndicatorInsets.bottom = keyboardHeight
        
        UIView.animateWithDuration(animationDuration.doubleValue, animations:({
            self.bodyTextView.contentInset = contentInset
            self.bodyTextView.scrollIndicatorInsets = scrollIndicatorInsets
            })
        )
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let animationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as NSNumber
        
        var contentInset = self.bodyTextView.contentInset
        contentInset.bottom = 0
        
        var scrollIndicatorInsets = self.bodyTextView.scrollIndicatorInsets
        scrollIndicatorInsets.bottom = 0
        
        UIView.animateWithDuration(animationDuration.doubleValue, animations:({
            self.bodyTextView.contentInset = contentInset
            self.bodyTextView.scrollIndicatorInsets = scrollIndicatorInsets
            })
        )
    }
    
    // MARK - other methods
    
    func updateNote() {
        var trimmedTitle = self.titleTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var trimmedBody = self.bodyTextView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        // delete note if both fields are blank
        if (note != nil && trimmedBody.isEmpty && trimmedTitle.isEmpty) {
            note!.deleteInManagedObjectContext((UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext)
        }
        
        // don't do anything if fields are empty
        if (trimmedBody.isEmpty && trimmedTitle.isEmpty) {
            return
        }
        
        // set default title if needed
        if trimmedTitle.isEmpty {
            trimmedTitle = "Untitled"
        }
        
        // set default body if needed
        if trimmedBody.isEmpty {
            trimmedBody = "New note"
        }
        
        // return if values are the same
        if (note != nil && self.note!.title == self.titleTextField.text && self.note!.body == self.bodyTextView.text) {
            return
        }
        
        // save is needed by this point
        self.saveNeeded = true
        
        if note == nil {
            note = Note.insertNewNoteInManagedObjectContext((UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext)
        }
        
        note?.update(title: trimmedTitle, body: trimmedBody)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation)  {
        self.showTextViewCaretPosition(self.bodyTextView)
    }
    
    func showTextViewCaretPosition(textView: UITextView!) {
        let caretRect = textView.caretRectForPosition(textView.selectedTextRange!.end)
        textView.scrollRectToVisible(caretRect, animated: false)
    }
    
    func hideTapToEditLabelIfNeeded() {
        if (self.bodyTextView.text.utf16Count > 0) {
            self.tapToEditTextField.hidden = true
        }
        else {
            self.tapToEditTextField.hidden = false
        }
    }
    
    func actionButtonTapped(sender: UIBarButtonItem!) {
        //TODO:
        //        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        //        activityIndicator.startAnimating()
        //
        //        self.navigationItem.rightBarButtonItem.customView = activityIndicator
        //
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ({
        //            let avd = UIActivityViewController(activityItems: "\(self.titleTextField.text)\(self.bodyTextView.text)", applicationActivities: nil)
        //            }))
    }
    
}
