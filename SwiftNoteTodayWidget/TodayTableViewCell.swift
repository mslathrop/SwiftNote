//
//  TodayViewTableViewCell.swift
//  SwiftNote
//
//  Created by Matthew Lathrop on 6/14/14.
//  Copyright (c) 2014 Matt Lathrop. All rights reserved.
//

import UIKit

class TodayTableViewCell: UITableViewCell {

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var bodyLabel: UILabel!
    
    func configure(#note:NoteProtocol!, indexPath:NSIndexPath!) {
        self.titleLabel.text = note.title;
        self.bodyLabel.text = note.body;
    }

}
