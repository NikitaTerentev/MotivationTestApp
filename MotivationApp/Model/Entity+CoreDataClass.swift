//
//  Entity+CoreDataClass.swift
//  MotivationApp
//
//  Created by Nikita on 15.11.2021.
//
//

import CoreData

@objc(Quotes)

class Quotes: NSManagedObject {
    @NSManaged var quote: String!
    @NSManaged var author: String!
    @NSManaged var deletedDate: Date? 
}
