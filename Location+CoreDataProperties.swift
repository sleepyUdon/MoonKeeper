//
//  Location+CoreDataProperties.swift
//  Moonrunner
//
//  Created by Viviane Chan on 2016-08-22.
//  Copyright © 2016 Magic Unicorn. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var timestamp: NSDate
    @NSManaged var run: NSManagedObject

}
