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
        if let double = Double(exactly: rawDate) {
            let date = NSDate(timeIntervalSince1970: double)
            payment.timestamp = date
        }
        return payment
    }
    
    func fetchOtherName() -> String {
        let pk = KeychainHelper.publicKey
        guard let from = from,
        let fromName = fromName,
        let toName = toName else { return "" }
        return from != pk ? fromName : toName
    }
    
    func fetchOtherImage() -> String {
        let pk = KeychainHelper.publicKey
        guard let from = from,
            let fromImage = fromImage,
            let toImage = toImage else { return "" }
        return from != pk ? fromImage : toImage
    }
    


    
}
