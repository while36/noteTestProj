//
//  ListViewController.swift
//  tinyNote1
//
//  Created by Mikhail on 30/11/15.
//  Copyright © 2015 Mikhail Zhadko. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    
    var fetchedResultController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView!.dataSource = self
        //self.tableView!.delegate = self
        
        let request = NSFetchRequest(entityName: "NoteList")
        let titleSort = NSSortDescriptor(key: "noteText", ascending: true)
        let subtitleSort = NSSortDescriptor(key: "noteCategory", ascending: true)
        let dateSort = NSSortDescriptor(key: "noteDate", ascending: true)
        request.sortDescriptors = [titleSort, subtitleSort, dateSort]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            print("Can't perform \(error.localizedDescription)")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
        }()
    
  
    
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
        let note = fetchedResultController.objectAtIndexPath(indexPath) as! NoteList
        let cell = tableView.dequeueReusableCellWithIdentifier("noteCell")!
        //cell.viewWithTag(1) = note.noteText
        if let titleLabel = self.view.viewWithTag(1) as? UILabel {
            titleLabel.text = note.noteText
        }
        if let subTitleLabel = self.view.viewWithTag(2) as? UILabel {
            subTitleLabel.text = note.noteCategory
        }
     /*   if let dateLabel = self.view.viewWithTag(3) as? UILabel {
            dateLabel.text = note.noteText
        }*/
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch editingStyle {
        case .Delete:
            let note = fetchedResultController.objectAtIndexPath(indexPath) as! NoteList
            context.deleteObject(note)
            
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
    
    
    @IBAction func addNote(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add category", message: nil, preferredStyle: .Alert)
        
        
        alert.addTextFieldWithConfigurationHandler { (noteCategory) -> Void in
            noteCategory.placeholder = "Enter category name"
        }
        alert.addTextFieldWithConfigurationHandler { (noteText) -> Void in
            noteText.placeholder = "Enter text"
        }

        
        let addAction = UIAlertAction(title: "Add", style: .Default) { _ in
            
            let entity = NSEntityDescription.entityForName("NoteList", inManagedObjectContext: self.context)
            
            let note = NoteList(entity:entity!, insertIntoManagedObjectContext: self.context)
            
            let textField = alert.textFields?.first
            note.noteCategory = textField?.text
            
            
            do {
                try self.context.save()
            } catch let error as NSError {
                print("Can't save a category \(error.localizedDescription)")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        // present the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}