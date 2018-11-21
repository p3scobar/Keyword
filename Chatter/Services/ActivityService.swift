//
//  ActivityService.swift
//  Sparrow
//
//  Created by Hackr on 8/5/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import Alamofire

struct ActivityService {
    
    static func fetchActivity(completion: @escaping ([Activity]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let urlString = "\(baseUrl)/activity"
            let url = URL(string: urlString)!
            let token = Model.shared.token
            let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
            let params: Parameters = [:]
            var notifications = [Activity]()
            notifications = Activity.fetchAll(in: PersistenceService.context)
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                guard let json = response.result.value as? [String:Any],
                    let resp = json["response"] as? [String:Any],
                    let results = resp["activity"] as? [[String:Any]] else { return }
            
                results.forEach({ (data) in
                    let id = data["_id"] as? String ?? ""
                    let activity = Activity.findOrCreateActivity(id: id, data: data, in: PersistenceService.context)
                    if !notifications.contains(activity) {
                        notifications.append(activity)
                    }
                })
                let sorted = notifications.sorted(by: { (s0, s1) -> Bool in
                    s0.timestamp > s1.timestamp
                })
                let unread = sorted.filter({ $0.unread == true }).count
                NotificationCenter.default.post(name: Notification.Name("notifications"), object: nil, userInfo: ["count":unread])
                completion(sorted)
            }
        }
    }
    
    
    static func markAllRead(completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let urlString = "\(baseUrl)/activity"
            let url = URL(string: urlString)!
            let token = Model.shared.token
            let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
            let params: Parameters = ["read":true.description]
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                if let error = response.error {
                    print(error.localizedDescription)
                } else {
                    Activity.markAllRead()
                    NotificationCenter.default.post(name: Notification.Name("notifications"), object: nil, userInfo: ["count":0])
                    completion(true)
                }
            }
        }
    }
    
}
