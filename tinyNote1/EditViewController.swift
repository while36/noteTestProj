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
    var selectedCategory = "default"
    var indexToDelete = NSIndexPath()
    var doneTapped = false
    var formatter = NSDateFormatter()
    var date:NSDate!
    var note = String()
    var categoryWasOpen = false
    var categoryShowed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.5)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.grayColor().CGColor
        textView.layer.borderColor = borderColor.CGColor
        textView.layer.cornerRadius = 7
        
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
        categoryShowed = true
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let vc = storyboard.instantiateViewControllerWithIdentifier("popover") as? UINavigationController{
            vc.modalPresentationStyle = UIModalPresentationStyle.Popover
            vc.preferredContentSize = CGSizeMake(200, 300)
            let popover: UIPopoverPresentationController = vc.popoverPresentationController!
            popover.barButtonItem = sender as? UIBarButtonItem
            
            if let tmpVc = vc.viewControllers[0]  as? PopoverViewController {
                tmpVc.category1 = self;
            }
            presentViewController(vc, animated: true, completion:nil)
        }
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
            note.noteCategory = self.note
            if (note.noteText!.isEmpty) {
            context.deleteObject(note)
            }
        } else {
            //let noteToEdit = self.noteFetchedResultController.objectAtIndexPath(indexToDelete) as? NoteList
           print(selectedCategory)
            if notePrototype!.noteText != textView.text {
                notePrototype!.noteDate = NSDate()
            }
            if categoryWasOpen {
                notePrototype!.noteCategory = selectedCategory
            }
            notePrototype!.noteText = textView.text
            

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
        let sharingVC = UIActivityViewController(activityItems: [textView.text], applicationActivities: [])
        presentViewController(sharingVC, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        print(categoryShowed, "weqwewww")
        if !doneTapped && !categoryShowed {
        self.saveAction(self)
        notePrototype = nil
        }
    }

    override func viewWillAppear(animated: Bool) {
        categoryShowed = false
    }
    
    
}
