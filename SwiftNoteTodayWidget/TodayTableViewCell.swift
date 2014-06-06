//
//  TodayTableViewCell.swift
//  SwiftNote
//
//  Created by Matthew Lathrop on 6/6/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UITextField
    
    @IBOutlet var bodyLabel: UILabel
    
    init(style: UITableViewCellStyle, reuseIdentifier: String!)  {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func configure(#note:NoteProtocol!, indexPath:NSIndexPath!) {
        self.titleLabel.text = note.title;
        self.bodyLabel.text = note.body;
    }
}
