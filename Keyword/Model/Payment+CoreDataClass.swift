//
//  Payment+CoreDataClass.swift
//  
//
//  Created by Hackr on 8/5/18.
//
//

import Foundation
import CoreData


enum PaymentType: String {
    case send = "send"
    case receive = "receive"
}


@objc(Payment)
public class Payment: NSManagedObject {
    
    static func findOrCreatePayment(id: String, data: [String:Any], in context: NSManagedObjectContext) -> Payment {
        let request: NSFetchRequest<Payment> = Payment.fetchRequest()
            request.predicate = NSPredicate(format: "id = %@", id)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Payment.findOrCreateStatus -- Database inconsistency")
                return matches[0]
            }
        } catch {
            let error = error
            print(error.localizedDescription)
        }
        let payment = Payment(context: context)
        payment.id = id
        payment.from = data["from"] as? String
        payment.fromImage = data["fromImage"] as? String
        payment.fromName = data["fromName"] as? String
        payment.fromUsername = data["fromUsername"] as? String
        payment.to = data["to"] as? String
        payment.toImage = data["toImage"] as? String
        payment.toName = data["toName"] as? String
        payment.toUsername = data["toUsername"] as? String
        payment.amount = data["amount"] as? String ?? "0.000"
        let rawDate = data["timestamp"] as? Int ?? 0
        if let double = Double(exactly: rawDate/1000) {
            let date = Date(timeIntervalSince1970: double)
            payment.timestamp = date
        }
        payment.isReceived = Model.shared.uuid == payment.to
        return payment
    }
    
    
    static func fetchAll(in context: NSManagedObjectContext) -> [Payment] {
        let request: NSFetchRequest<Payment> = Payment.fetchRequest()
        request.fetchLimit = 100
        var payments: [Payment] = []
        do {
            payments = try context.fetch(request)
        } catch {
            let error = error
            print(error.localizedDescription)
        }
        return payments
    }
    
    static func deleteAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Payment")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let container = PersistenceService.persistentContainer
        do {
            try container.viewContext.execute(deleteRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}


extension Payment {
    
    func fetchOtherName() -> String {
        let pk = KeychainHelper.publicKey
        guard let from = from,
            let fromName = fromName,
            let toName = toName else { return "" }
        return from != pk ? fromName : toName
    }
    
    
    func fetchOtherUsername() -> String {
        let pk = KeychainHelper.publicKey
        guard let from = from,
            let fromUsername = fromUsername,
            let toUsername = toUsername else { return "" }
        return from != pk ? fromUsername : toUsername
    }
    
    func fetchOtherImage() -> String {
        let pk = KeychainHelper.publicKey
        let fromImageUrl = fromImage ?? ""
        let toImageUrl = toImage ?? ""
        return from != pk ? fromImageUrl : toImageUrl
    }
    
}
