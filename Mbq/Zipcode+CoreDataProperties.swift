//
//  Zipcode+CoreDataProperties.swift
//  Mbq
//
//  Created by Buwaneka Galpoththawela on 4/25/16.
//  Copyright © 2016 Buwaneka Galpoththawela. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Zipcode {

    @NSManaged var zipcode: String?
    @NSManaged var city: String?
    @NSManaged var userID: String?
    @NSManaged var dateEntered: NSDate?
    @NSManaged var dateUpdated: NSDate?

}
