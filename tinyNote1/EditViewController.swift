//
//  EditViewController.swift
//  tinyNote1
//
//  Created by Mikhail on 30/11/15.
//  Copyright © 2015 Mikhail Zhadko. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var notePrototype: NoteList!
    @IBOutlet weak var textView: UITextView!
    var fetchedResultController: NSFetchedResultsController!
    var selectedCategory = String()
    var indexToDelete = NSIndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.enabled = false
        if notePrototype != nil {
            textView.text = notePrototype.noteText
            selectedCategory = notePrototype.noteCategory!
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)

        let request = NSFetchRequest(entityName: "CategoryList")
        let categorySort = NSSortDescriptor(key: "categoryName", ascending: true)
        request.sortDescriptors = [categorySort]
        
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
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
    
    @IBAction func showCategory(sender: AnyObject) {
        let alertController = UIAlertController(title: "Category", message: "Choose one", preferredStyle: .Alert)
        let sectionData = fetchedResultController.sections![1]
        for index in 0...sectionData.numberOfObjects {
            var action = UIAlertAction(title: <#T##String?#>, style: <#T##UIAlertActionStyle#>, handler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>)
        }
        
        
        
//        if(tableView.hidden) {
//            tableView.hidden = false
//        } else {
//            tableView.hidden = true
//        }
    }
    @IBAction func saveAction(sender: AnyObject) {
        
        self.view.endEditing(true)
        doneButton.enabled = false
        if notePrototype == nil {
            let entity = NSEntityDescription.entityForName("NoteList", inManagedObjectContext: self.context)
            let note = NoteList(entity:entity!, insertIntoManagedObjectContext: self.context)
            note.noteText = textView.text
            note.noteDate = NSDate()
            note.noteCategory = selectedCategory
            print(selectedCategory, "1112")
        } else {
            notePrototype.noteText = textView.text
            notePrototype.noteCategory = selectedCategory
            notePrototype.noteDate = NSDate()
        }
        do {
            try self.context.save()
        }
        catch let error as NSError {
            print("Can't save a category \(error.localizedDescription)")
        }
        var indexPath = NSIndexPath(forRow: Int, inSection: <#T##Int#>)
        
    }
    
    func keyboardWillShow(notification:NSNotification) {
        doneButton.enabled = true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionData = fetchedResultController.sections?[section] else {
            return 1
        }
        return sectionData.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let category = fetchedResultController.objectAtIndexPath(indexPath) as! CategoryList
        let cell = tableView.dequeueReusableCellWithIdentifier("DropUpCell")!
        selectedCategory = category.categoryName!
        cell.textLabel?.text = category.categoryName
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let category = fetchedResultController.objectAtIndexPath(indexPath) as! CategoryList
        selectedCategory = category.categoryName!
        tableView.hidden = true
    }
    @IBAction func deleteNote(sender: AnyObject) {
//        let note = fetchedResultController.objectAtIndexPath(indexToDelete) as! NoteList
//        context.deleteObject(note)
//        
//        do {
//            try context.save()
//        } catch let error as NSError {
//            print("Error saving context after delete: \(error.localizedDescription)")
//        }
        
    }
    override func viewWillDisappear(animated: Bool) {
        self.saveAction(self)
    }
}
