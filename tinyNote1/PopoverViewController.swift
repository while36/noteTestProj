//
//  PopoverViewController.swift
//  tinyNote1
//
//  Created by User on 11.12.15.
//  Copyright © 2015 Mikhail Zhadko. All rights reserved.
//

import UIKit
import CoreData


class PopoverViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var fetchedResultController: NSFetchedResultsController!
//    var delegate:ModalViewControllerDelegate!
    
    var category1: EditViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let categoryRequest = NSFetchRequest(entityName: "CategoryList")
        let categorySort = NSSortDescriptor(key: "categoryName", ascending: true)
        categoryRequest.sortDescriptors = [categorySort]
        
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: categoryRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            print("Cant't perform text \(error.localizedDescription)")
        }
    }

    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sectionCount = fetchedResultController.sections?.count else {
            return 0
        }
        return sectionCount
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionData = fetchedResultController.sections?[section] else {
            return 1
        }
        return sectionData.numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let category = fetchedResultController.objectAtIndexPath(indexPath) as! CategoryList
        let cell = tableView.dequeueReusableCellWithIdentifier("popoverCell")!
        cell.textLabel?.text = category.categoryName
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.dismissViewControllerAnimated(true, completion: nil)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        category1?.selectedCategory = (cell?.textLabel?.text)!
        category1!.categoryWasOpen = true
        category1!.categoryShowed = false
        category1?.doneTapped = false
        
    }
    @IBAction func cancelPopover(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        category1!.categoryShowed = false
        category1?.doneTapped = false
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
