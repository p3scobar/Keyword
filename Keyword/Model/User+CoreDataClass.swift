//
//  User+CoreDataClass.swift
//  
//
//  Created by Hackr on 7/28/18.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {

    static func findOrCreateUser(id: String, data: [String:Any], in context: NSManagedObjectContext) -> User {
        let request: NSFetchRequest<User> = User.fetchRequest()
        if let id = data["_id"] as? String {
            request.predicate = NSPredicate(format: "id = %@", id)
        }
        do {
            let match = try context.fetch(request)
            if match.count > 0 {
                assert(match.count == 1, "User.findOrCreateStatus -- Database inconsistency")
                let fetchedUser = match[0]
                fetchedUser.id = id
                let profileImageUrl = data["profile"] as? String ?? ""
                fetchedUser.image = profileImageUrl
                fetchedUser.name = data["name"] as? String
                fetchedUser.username = data["username"] as? String
                fetchedUser.bio = data["bio"] as? String
                fetchedUser.publicKey = data["publicKey"] as? String
                return fetchedUser
            }
        } catch {
            let error = error
            print(error.localizedDescription)
        }
        let user = User(context: context)
        user.id = id
        user.bio = data["bio"] as? String
        let profileImageUrl = data["profile"] as? String ?? ""
        user.image = profileImageUrl
        user.name = data["name"] as? String
        user.username = data["username"] as? String
        user.publicKey = data["publicKey"] as? String
        PersistenceService.saveContext()
        return user
    }
    
}
