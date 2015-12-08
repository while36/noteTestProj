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
    var watchDictionary: AnyObject!
    var session : WCSession!
    
    
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
            watchDictionary = values
            print(watchDictionary)
        }
        
        print(watchDictionary[0].valueForKey("categoryName"))
    }
    
    func setupTable() {
        watchTable.setNumberOfRows(watchDictionary.count, withRowType: "WatchRow")
        for index in 0...watchDictionary.count - 1 {
            let row = watchTable.rowControllerAtIndex(index) as! CategoryRowController
            row.categoryLabel.setText(watchDictionary[index].valueForKey("categoryName") as? String)
        }
        
    }
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        runAfterDelay(5) {
            self.setupTable()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
