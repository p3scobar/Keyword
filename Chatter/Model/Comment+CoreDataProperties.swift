//
//  Comment+CoreDataProperties.swift
//  
//
//  Created by Hackr on 8/4/18.
//
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var userId: String?
    @NSManaged public var name: String?
    @NSManaged public var username: String?
    @NSManaged public var userImage: String?

}
