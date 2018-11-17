//
//  Status+CoreDataClass.swift
//  
//
//  Created by Hackr on 7/28/18.
//
//

import Foundation
import CoreData

@objc(Status)
public class Status: NSManagedObject {
    
    static func findOrCreateStatus(id: String, data: [String:Any], in context: NSManagedObjectContext) -> Status {
        let request: NSFetchRequest<Status> = Status.fetchRequest()
        if let id = data["_id"] as? String {
            request.predicate = NSPredicate(format: "id = %@", id)
        }
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                //assert(matches.count > 1, "Status.findOrCreateStatus -- Database inconsistency")
                let fetched = matches[0]
                fetched.id = id
                fetched.text = data["text"] as? String
                fetched.image = data["image"] as? String
                fetched.userId = data["userId"] as? String
                fetched.name = data["name"] as? String
                fetched.username = data["username"] as? String
                fetched.userImage = data["userImage"] as? String ?? ""
                fetched.inReplyToId = data["inReplyToId"] as? String
                fetched.inReplyToUserId = data["inReplyToUserId"] as? String
                fetched.inReplyToText = data["inReplyToText"] as? String
                fetched.inReplyToName = data["inReplyToName"] as? String
                fetched.inReplyToUserImage = data["inReplyToUserImage"] as? String
                fetched.link = data["link"] as? String
                
                if let imageUrl = data["linkImage"] as? String {
                    let host = "https:"
                    fetched.linkImage = host+imageUrl
                }
                fetched.linkTitle = data["linkTitle"] as? String
                fetched.likeCount = data["likeCount"] as? Int16 ?? 0
                
                PersistenceService.saveContext()
                return fetched
            }
        } catch {
            let error = error
            print(error.localizedDescription)
        }
        let status = Status(context: context)
        status.id = id
        status.text = data["text"] as? String
        status.image = data["image"] as? String
        status.userId = data["userId"] as? String
        status.name = data["name"] as? String
        status.username = data["username"] as? String
        status.userImage = data["userImage"] as? String ?? ""
        let rawDate = data["timestamp"] as? Int ?? 0
        if let double = Double(exactly: rawDate/1000) {
            let date = NSDate(timeIntervalSince1970: double)
            status.timestamp = date
        }
        status.inReplyToId = data["inReplyToId"] as? String
        status.inReplyToUserId = data["inReplyToUserId"] as? String
        status.inReplyToText = data["inReplyToText"] as? String
        status.inReplyToName = data["inReplyToName"] as? String
        status.inReplyToUserImage = data["inReplyToUserImage"] as? String
        status.link = data["link"] as? String
        if let imageUrl = data["linkImage"] as? String {
            let host = "https:"
            status.linkImage = host+imageUrl
        }
        status.linkTitle = data["linkTitle"] as? String
        status.likeCount = data["likeCount"] as? Int16 ?? 0
        
        PersistenceService.saveContext()
        return status
    }
    
    
}






