//
//  Status+CoreDataProperties.swift
//  
//
//  Created by Hackr on 7/28/18.
//
//

import Foundation
import CoreData


extension Status {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Status> {
        return NSFetchRequest<Status>(entityName: "Status")
    }

    @NSManaged public var id: String
    @NSManaged public var userId: String?
    @NSManaged public var name: String?
    @NSManaged public var username: String?
    @NSManaged public var userImage: String?
    @NSManaged public var text: String?
    @NSManaged public var image: String?
    @NSManaged public var link: String?
    @NSManaged public var linkImage: String?
    @NSManaged public var linkTitle: String?
    
    @NSManaged public var timestamp: Date
    @NSManaged public var likeCount: Int16
    @NSManaged public var commentCount: Int16

    @NSManaged public var inReplyToId: String?
    @NSManaged public var inReplyToUserId: String?
    @NSManaged public var inReplyToText: String?
    @NSManaged public var inReplyToName: String?
    @NSManaged public var inReplyToUserImage: String?
}





