//
//  Note.swift
//  tinyNote1
//
//  Created by Mikhail on 02/12/15.
//  Copyright © 2015 Mikhail Zhadko. All rights reserved.
//

import Foundation
import CoreData

class NoteList: NSManagedObject {
    
}

extension NoteList {
    
    @NSManaged var noteCategory: String?
    @NSManaged var noteText: String?
    @NSManaged var noteDate: NSDate?
    
}