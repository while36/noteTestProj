//
//  ListInterfaceController.swift
//  tinyNote1
//
//  Created by User on 09.12.15.
//  Copyright © 2015 Mikhail Zhadko. All rights reserved.
//

import WatchKit
import Foundation



class ListInterfaceController: WKInterfaceController {
    @IBOutlet var watchTable: WKInterfaceTable!
    @IBOutlet var categoryLabel: WKInterfaceLabel!

    var noteText:AnyObject!
    var noteDate:AnyObject!
    var noteCategory:AnyObject!
        
    override init() {
        super.init()
        
    }
    
    func setupTable() {
        watchTable.setNumberOfRows(noteText.count, withRowType: "NoteRow")
        for index in 0...noteText.count - 1 {
            let row = watchTable.rowControllerAtIndex(index) as! NoteRowController
            row.textLabel.setText(noteText[index] as? String)
            print(noteDate[index])
            row.dateLabel.setText(noteDate[index] as? String)
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        noteText = context![0]
        noteDate = context![1]
        noteCategory = context![2]
        categoryLabel.setText(noteCategory as? String)
        print(context)
        print(noteText)
        setupTable()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        if segueIdentifier == "ListToNote" {
            let temp = [noteText[rowIndex], noteDate[rowIndex], noteCategory]
            return temp
        }
        return nil
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
