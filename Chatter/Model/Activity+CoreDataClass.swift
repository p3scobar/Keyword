//
//  Activity+CoreDataClass.swift
//  
//
//  Created by Hackr on 7/28/18.
//
//

import Foundation
import CoreData

@objc(Activity)
public class Activity: NSManagedObject {

    static func findOrCreateActivity(id: String, data: [String:Any], in context: NSManagedObjectContext) -> Activity {
        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
        if let id = data["_id"] as? String {
            request.predicate = NSPredicate(format: "id = %@", id)
        }
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Activity.findOrCreateStatus -- Database inconsistency")
                let item = matches[0]
                item.id = id
                item.type = data["type"] as? String
                item.name = data["name"] as? String
                item.username = data["username"] as? String
                item.userId = data["userId"] as? String
                item.userImage = data["userImage"] as? String
                return item
            }
        } catch {
            let error = error
            print(error.localizedDescription)
        }
        let activity = Activity(context: context)
        activity.id = id
        activity.type = data["type"] as? String
        activity.text = data["text"] as? String
        activity.statusId = data["postId"] as? String
        activity.name = data["name"] as? String
        activity.username = data["username"] as? String
        activity.userId = data["userId"] as? String
        activity.userImage = data["userImage"] as? String
        return activity
    }
    
}
