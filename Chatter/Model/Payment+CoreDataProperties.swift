//
//  Payment+CoreDataProperties.swift
//  
//
//  Created by Hackr on 9/4/18.
//
//

import Foundation
import CoreData


extension Payment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Payment> {
        return NSFetchRequest<Payment>(entityName: "Payment")
    }

    @NSManaged public var timestamp: Date
    @NSManaged public var amount: String?
    @NSManaged public var from: String?
    @NSManaged public var fromImage: String?
    @NSManaged public var fromName: String?
    @NSManaged public var fromUsername: String?
    @NSManaged public var id: String?
    @NSManaged public var to: String?
    @NSManaged public var toImage: String?
    @NSManaged public var toName: String?
    @NSManaged public var toUsername: String?
    @NSManaged public var isReceived: Bool

}
