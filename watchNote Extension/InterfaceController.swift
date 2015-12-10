//
//  InterfaceController.swift
//  watchNote Extension
//
//  Created by User on 04.12.15.
//  Copyright © 2015 Mikhail Zhadko. All rights reserved.

import WatchConnectivity
import WatchKit
import Foundation
import CoreData


class InterfaceController: WKInterfaceController,WCSessionDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var watchTable: WKInterfaceTable!
    var watchDictionary : AnyObject!
    var session : WCSession!
    var categoryName : NSSet!
    var noteText = [String]()
    var noteDate = [String]()
    let formatter = NSDateFormatter()
    var defaults = NSUserDefaults.standardUserDefaults()
    var dicFromApp :  AnyObject!
    
    
    override init() {
        super.init()
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
    }

    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        for values in applicationContext.values {
            dicFromApp = values
        }
        
    }
    
    func setupTable() {
        if dicFromApp == nil {
            watchDictionary = defaults.objectForKey("defaultsKey")
        } else {
            watchDictionary = dicFromApp
            defaults.setObject(dicFromApp, forKey: "defaultsKey")
        }
        let temp:NSMutableArray = []
        for index in 0...watchDictionary.count - 1 {
            temp.insertObject(watchDictionary[index].valueForKey("noteCategory")!, atIndex: index)
        }
        categoryName = NSSet(array: temp as [AnyObject])
        if categoryName == nil {
            watchTable.setNumberOfRows(1, withRowType: "WatchRow")
            let row = watchTable.rowControllerAtIndex(0) as! CategoryRowController
            row.categoryLabel.setText("Run iPhone app and relaunch watch to get info")
        } else {
        
        watchTable.setNumberOfRows(categoryName.count, withRowType: "WatchRow")
            for index in 0...categoryName.count - 1 {
                let row = watchTable.rowControllerAtIndex(index) as! CategoryRowController
                row.categoryLabel.setText(categoryName.allObjects[index] as? String)
            }
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        formatter.dateFormat = "MM-dd-yyyy"
        if segueIdentifier == "categoryToNote" {
            noteText.removeAll()
            noteDate.removeAll()
            for index in 0...watchDictionary.count - 1 {
                if ((watchDictionary[index].valueForKey("noteCategory") as! String) == (categoryName.allObjects[rowIndex] as! String)) {
                    noteText.append(watchDictionary[index].valueForKey("noteText") as! String)
                    noteDate.append(formatter.stringFromDate(watchDictionary[index].valueForKey("noteDate") as! NSDate))
                }
            }
            let temp = [noteText, noteDate, categoryName.allObjects[rowIndex]]
            return temp
        }
        return nil
    }

    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
//    
//    func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
//        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
//        dispatch_after(time, dispatch_get_main_queue(), block)
//    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.setupTable()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
