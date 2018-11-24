//
//  User+CoreDataProperties.swift
//  
//
//  Created by Hackr on 7/28/18.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String?
    @NSManaged public var bio: String?
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var publicKey: String?
    @NSManaged public var username: String?

}
