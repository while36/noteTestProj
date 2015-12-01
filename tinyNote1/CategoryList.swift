//
//  CategoryList.swift
//  tinyNote1
//
//  Created by Mikhail on 01/12/15.
//  Copyright © 2015 Mikhail Zhadko. All rights reserved.
//

import Foundation
import CoreData

class CategoryList: NSManagedObject {
    
}

extension CategoryList {
    
    @NSManaged var categoryName: String?
    @NSManaged var releaseDate: NSDate?
    
}