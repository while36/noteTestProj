//
//  InterfaceController.swift
//  watchNote Extension
//
//  Created by User on 04.12.15.
//  Copyright © 2015 Mikhail Zhadko. All rights reserved.


import WatchKit
import Foundation
import CoreData


class InterfaceController: WKInterfaceController, NSFetchedResultsControllerDelegate {

    @IBOutlet var watchTable: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
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
