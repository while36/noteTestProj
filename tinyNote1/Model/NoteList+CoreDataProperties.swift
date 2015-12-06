//
//  NoteList+CoreDataProperties.swift
//  tinyNote1
//
//  Created by User on 02.12.15.
//  Copyright © 2015 Mikhail Zhadko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension NoteList {

    @NSManaged var noteCategory: String?
    @NSManaged var noteDate: NSDate?
    @NSManaged var noteText: String?
    @NSManaged var relationshipCategoryList: CategoryList?

}
