//
//  EditViewController.swift
//  tinyNote1
//
//  Created by Mikhail on 30/11/15.
//  Copyright © 2015 Mikhail Zhadko. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController, NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var notePrototype: NoteList?
    @IBOutlet weak var textView: UITextView!
    var fetchedResultController: NSFetchedResultsController!
    var noteFetchedResultController: NSFetchedResultsController!
    var selectedCategory = "1"
    var indexToDelete = NSIndexPath()
    var doneTapped = false
    var formatter = NSDateFormatter()
    var date:NSDate!
    var note = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateStyle = .FullStyle
        doneButton.enabled = false
        if notePrototype != nil {
            print(notePrototype!.noteText)
            textView.text = notePrototype!.noteText
            selectedCategory = notePrototype!.noteCategory!
            dateLabel.text = formatter.stringFromDate(date)
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        let noteRequest = NSFetchRequest(entityName: "NoteList")
        let titleSort = NSSortDescriptor(key: "noteText", ascending: true)
        let subtitleSort = NSSortDescriptor(key: "noteCategory", ascending: true)
        let dateSort = NSSortDescriptor(key: "noteDate", ascending: true)
        noteRequest.sortDescriptors = [titleSort, subtitleSort, dateSort]
        noteRequest.sortDescriptors = [NSSortDescriptor(key: "noteDate", ascending: false)]

        noteFetchedResultController = NSFetchedResultsController(fetchRequest: noteRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        noteFetchedResultController.delegate = self
        
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
        do {
            try noteFetchedResultController.performFetch()
        } catch let error as NSError {
            print("Cant't perform text \(error.localizedDescription)")
        }
        
    }
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    @IBAction func showCategory(sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("popover")
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.barButtonItem = sender as? UIBarButtonItem
        presentViewController(vc, animated: true, completion:nil)
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        doneTapped = true
        self.view.endEditing(true)
        doneButton.enabled = false
        if notePrototype == nil {
            let entity = NSEntityDescription.entityForName("NoteList", inManagedObjectContext: self.context)
            let note = NoteList(entity:entity!, insertIntoManagedObjectContext: self.context)
            note.noteText = textView.text
            note.noteDate = NSDate()
            note.noteCategory = selectedCategory
        } else {
            //let noteToEdit = self.noteFetchedResultController.objectAtIndexPath(indexToDelete) as? NoteList
            if notePrototype!.noteText != textView.text {
                notePrototype!.noteDate = NSDate()
            }
            notePrototype!.noteText = textView.text
            notePrototype!.noteCategory = selectedCategory

        }
        do {
            try self.context.save()
        }
        catch let error as NSError {
            print("Can't save a category \(error.localizedDescription)")
        }
        
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
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let category = fetchedResultController.objectAtIndexPath(indexPath) as! CategoryList
//        let cell = tableView.dequeueReusableCellWithIdentifier("DropUpCell")!
//        selectedCategory = category.categoryName!
//        cell.textLabel?.text = category.categoryName
//        return cell
//    }
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        let category = fetchedResultController.objectAtIndexPath(indexPath) as! CategoryList
//        selectedCategory = category.categoryName!
//        tableView.hidden = true
//    }
    @IBAction func deleteNote(sender: AnyObject) {
        context.deleteObject(notePrototype!)
        self.navigationController?.popViewControllerAnimated(true)
        do {
            try context.save()
        } catch let error as NSError {
            print("Error saving context after delete: \(error.localizedDescription)")
        }
        
    }
    
    @IBAction func showSharing(sender: AnyObject) {
        performSegueWithIdentifier("delete", sender: self)
        let sharingVC = UIActivityViewController(activityItems: [textView.text], applicationActivities: [])
        presentViewController(sharingVC, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        if !doneTapped {
        self.saveAction(self)
        }
        notePrototype = nil
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.FullScreen
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
        let btnDone = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss")
        navigationController.topViewController!.navigationItem.rightBarButtonItem = btnDone
        return navigationController
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
