//
//  CategoryList+CoreDataProperties.swift
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

extension CategoryList {

    @NSManaged var categoryName: String?
    @NSManaged var relationshipNoteList: NSSet?

}
