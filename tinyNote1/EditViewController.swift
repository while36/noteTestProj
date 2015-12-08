//
//  EditViewController.swift
//  tinyNote1
//
//  Created by Mikhail on 30/11/15.
//  Copyright © 2015 Mikhail Zhadko. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController, NSFetchedResultsControllerDelegate {


    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var textToEdit: String = ""
    @IBOutlet weak var textView: UITextView!
    var fetchedResultController: NSFetchedResultsController!
    var selectedCategory:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.enabled = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        textView.text = textToEdit
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
        if(pickerView.hidden) {
            pickerView.hidden = false
        } else {
            pickerView.hidden = true
        }
    }
    @IBAction func saveAction(sender: AnyObject) {
        
        self.view.endEditing(true)
        doneButton.enabled = false
        
//        let predicate = NSPredicate(format: "objectID == %@", objectIDFromNSManagedObject)
//        
//        let fetchRequest = NSFetchRequest(entityName: "MyEntity")
//        fetchRequest.predicate = predicate
//        
//        do {
//            let fetchedEntities = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [MyEntity]
//            fetchedEntities.first?.FirstPropertyToUpdate = NewValue
//            fetchedEntities.first?.SecondPropertyToUpdate = NewValue
//            // ... Update additional properties with new values
//        } catch {
//            // Do something in response to error condition
//        }
//        
//        do {
//            try self.managedObjectContext.save()
//        } catch {
//            // Do something in response to error condition
//        }
        
        let entity = NSEntityDescription.entityForName("NoteList", inManagedObjectContext: self.context)
        let note = NoteList(entity:entity!, insertIntoManagedObjectContext: self.context)
        note.noteText = textView.text
        note.noteDate = NSDate()
        note.noteCategory = selectedCategory
            print(selectedCategory, "1112")
        
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Can't save a category \(error.localizedDescription)")
        }
        
    }
    
    func keyboardWillShow(notification:NSNotification) {
        doneButton.enabled = true
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent section: Int) -> Int {
        guard let sectionData = fetchedResultController.sections?[section] else {
            return 1
        }
        return sectionData.numberOfObjects
    }
    func pickerView(pickerView: UIPickerView, titleForRow row:Int, forComponent section: Int) -> String! {
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        let category = fetchedResultController.objectAtIndexPath(indexPath) as! CategoryList
        selectedCategory = category.categoryName!
        return category.categoryName
    }
    
}
