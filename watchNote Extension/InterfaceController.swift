//
//  InterfaceController.swift
//  watchNote Extension
//
//  Created by User on 04.12.15.
//  Copyright © 2015 Mikhail Zhadko. All rights reserved.
//

//import WatchKit
//import Foundation
//import CoreData
//
//
//class InterfaceController: WKInterfaceController, NSFetchedResultsControllerDelegate {
//
//    @IBOutlet var watchTable: WKInterfaceTable!
//    var fetchedResultController: NSFetchedResultsController
//    
//    override func awakeWithContext(context: AnyObject?) {
//        super.awakeWithContext(context)
//        
//        // Configure interface objects here.
//    }
//
//    override init() {
//        super.init()
//    }
//    
//    override func willActivate() {
//        // This method is called when watch view controller is about to be visible to user
//        super.willActivate()
//    
////        fetchData()
////
////    }
////    
//////    func fetchData(){
//////    let request = NSFetchRequest(entityName: "CategoryList")
//////    let titleSort = NSSortDescriptor(key: "categoryName", ascending: true)
//////    request.sortDescriptors = [titleSort]
//////    
//////    fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//////    fetchedResultController.delegate = self
//////    
//////    do {
//////    try fetchedResultController.performFetch()
//////    } catch let error as NSError {
//////    print("Can't perform \(error.localizedDescription)")
//////    }
//////    }
//////    
//////    lazy var context: NSManagedObjectContext = {
//////        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//////        return appDelegate.managedObjectContext
//////    }()
//
//    override func didDeactivate() {
//        // This method is called when watch view controller is no longer visible
//        super.didDeactivate()
//    }
//
//}
