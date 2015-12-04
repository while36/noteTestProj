//
//  ViewController.swift
//  tinyNote1
//
//  Created by Mikhail on 30/11/15.
//  Copyright © 2015 Mikhail Zhadko. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "categoryToNote"  {
            if let destination = segue.destinationViewController as? ListViewController {
                let indexPath = self.tableView.indexPathForSelectedRow!
                let selectedObject = self.fetchedResultController.objectAtIndexPath(indexPath) as? CategoryList
                destination.note = selectedObject!.categoryName!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView!.dataSource = self
        //self.tableView!.delegate = self
        
        let request = NSFetchRequest(entityName: "CategoryList")
        let titleSort = NSSortDescriptor(key: "categoryName", ascending: true)
        request.sortDescriptors = [titleSort]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            print("Can't perform \(error.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
        }()
    
    var fetchedResultController: NSFetchedResultsController!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sectionCount = fetchedResultController.sections?.count else {
            return 0
        }
        return sectionCount
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionData = fetchedResultController.sections?[section] else {
            return 1
        }
        return sectionData.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let category = fetchedResultController.objectAtIndexPath(indexPath) as! CategoryList
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell")!
        cell.textLabel?.text = category.categoryName
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch editingStyle {
        case .Delete:
            let category = fetchedResultController.objectAtIndexPath(indexPath) as! CategoryList
            context.deleteObject(category)
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Error saving context after delete: \(error.localizedDescription)")
            }
        default:break
        }
    }
    
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView?.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView?.endUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            tableView?.insertSections(NSIndexSet(index:sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            tableView?.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default: break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView?.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView?.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        default: break
        }
        
        
    }
    
    
    @IBAction func addCategory(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add category", message: nil, preferredStyle: .Alert)
        
        
        alert.addTextFieldWithConfigurationHandler { (categoryName) -> Void in
            categoryName.placeholder = "Enter category name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .Default) { _ in
            
            let entity = NSEntityDescription.entityForName("CategoryList", inManagedObjectContext: self.context)
            
            let category = CategoryList(entity:entity!, insertIntoManagedObjectContext: self.context)
            
            let textField = alert.textFields?.first
            category.categoryName = textField?.text
            
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Can't save a category \(error.localizedDescription)")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

