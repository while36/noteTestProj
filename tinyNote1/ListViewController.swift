//
//  ListViewController.swift
//  tinyNote1
//
//  Created by Mikhail on 30/11/15.
//  Copyright © 2015 Mikhail Zhadko. All rights reserved.
//
import UIKit
import CoreData
import WatchConnectivity

class ListViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate,WCSessionDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    var note = String()
    var session: WCSession!
    
    let formatter = NSDateFormatter()
    
    var fetchedResultController: NSFetchedResultsController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "notesToEdit"  {
            if let destination = segue.destinationViewController as? EditViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                let selectedObject = fetchedResultController.objectAtIndexPath(indexPath) as? NoteList
                print(fetchedResultController.objectAtIndexPath(indexPath) as? NoteList)
                //tableView.reloadData()
                destination.notePrototype = selectedObject
                destination.indexToDelete = indexPath
                destination.date = selectedObject!.noteDate!
                destination.note = self.note
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView!.dataSource = self
        self.tableView!.delegate = self
        if(WCSession.isSupported()) {
            self.session = WCSession.defaultSession()
            self.session.delegate = self
            self.session.activateSession()
            let watchRequest = NSFetchRequest(entityName: "NoteList")
            let titleSort = NSSortDescriptor(key: "noteCategory", ascending: true)
            let textSort = NSSortDescriptor(key: "noteText", ascending: true)
            let dateSort = NSSortDescriptor(key: "noteDate", ascending: true)
            watchRequest.sortDescriptors = [titleSort, textSort, dateSort]
            watchRequest.sortDescriptors = [NSSortDescriptor(key: "noteDate", ascending: false)]
            watchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
            
            do {
                let results:NSArray = try context.executeFetchRequest(watchRequest)
                let dicForWatch:[String:AnyObject] = ["1":results]
                try session.updateApplicationContext(dicForWatch)
                
            } catch  let error as NSError {print(error) }
            
        }
        
        let request = NSFetchRequest(entityName: "NoteList")
        let titleSort = NSSortDescriptor(key: "noteText", ascending: true)
        let subtitleSort = NSSortDescriptor(key: "noteCategory", ascending: true)
        let dateSort = NSSortDescriptor(key: "noteDate", ascending: true)
        request.sortDescriptors = [titleSort, subtitleSort, dateSort]
        request.predicate = NSPredicate(format: "noteCategory = %@", argumentArray: [note])
        request.sortDescriptors = [NSSortDescriptor(key: "noteDate", ascending: false)]
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            print("Can't perform \(error.localizedDescription)")
        }
        tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
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
        formatter.dateFormat = "yyyy-MM-dd"
        let note = fetchedResultController.objectAtIndexPath(indexPath) as! NoteList
        let cell = tableView.dequeueReusableCellWithIdentifier("noteCell")!
        if note.noteCategory == self.note {
            print(note.noteText, "sssssssss")
            cell.textLabel?.text = note.noteText
            cell.detailTextLabel?.text = formatter.stringFromDate(note.noteDate!)
        }
        
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
            tableView?.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
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
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
}