//
//  Like+CoreDataProperties.swift
//  
//
//  Created by Hackr on 11/17/18.
//
//

import Foundation
import CoreData


extension Like {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Like> {
        return NSFetchRequest<Like>(entityName: "Like")
    }

    @NSManaged public var postId: String?
    @NSManaged public var userId: String?

}
