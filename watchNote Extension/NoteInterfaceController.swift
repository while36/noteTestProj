//
//  NoteInterfaceController.swift
//  tinyNote1
//
//  Created by User on 10.12.15.
//  Copyright © 2015 Mikhail Zhadko. All rights reserved.
//

import WatchKit
import Foundation


class NoteInterfaceController: WKInterfaceController {
    @IBOutlet var dateLabel: WKInterfaceLabel!
    @IBOutlet var categoryLabel: WKInterfaceLabel!
    @IBOutlet var textLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        textLabel.setText(context![0] as? String)
        dateLabel.setText(context![1] as? String)
        categoryLabel.setText(context![2] as? String)
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
