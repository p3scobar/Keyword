//
//  Activity+CoreDataProperties.swift
//  
//
//  Created by Hackr on 8/5/18.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var id: String?
    @NSManaged public var type: String?
    @NSManaged public var text: String?
    @NSManaged public var timestamp: Date
    @NSManaged public var unread: Bool
    @NSManaged public var statusId: String?
    @NSManaged public var name: String?
    @NSManaged public var username: String?
    @NSManaged public var userId: String?
    @NSManaged public var userImage: String?
    

}
