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
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                var notifications = [Activity]()
                print(response)
                guard let json = response.result.value as? [String:Any],
                    let resp = json["response"] as? [String:Any],
                    let results = resp["activity"] as? [[String:Any]] else { return }
            
                results.forEach({ (data) in
                    let id = data["_id"] as? String ?? ""
                    let activity = Activity.findOrCreateActivity(id: id, data: data, in: PersistenceService.context)
                    notifications.append(activity)
                })
                completion(notifications)
            }
        }
    }
    
}
