//
//  NewsService.swift
//  Sparrow
//
//  Created by Hackr on 7/27/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import Alamofire
import CoreData
import FirebaseStorage

struct NewsService {
    
    static func discover(cursor: Int, completion: @escaping ([Status], [User]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let urlString = "\(baseUrl)/discover"
            let url = URL(string: urlString)!
            let token = Model.shared.token
            let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
            let params: [String:Any] = ["sort_field":"timestamp","descending":false, "cursor":cursor]
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                print(response)
                var feed = [Status]()
                var users = [User]()
                guard let json = response.result.value as? [String:Any],
                    let resp = json["response"] as? [String:Any],
                    let posts = resp["posts"] as? [[String:Any]] else {
                        completion([],[])
                        return
                }
                posts.forEach({ (postData) in
                    let id = postData["_id"] as? String ?? ""
                    let status = Status.findOrCreateStatus(id: id, data: postData, in: PersistenceService.context)
                    feed.append(status)
                })
                if let people = resp["users"] as? [[String:Any]] {
                    people.forEach({ (userData) in
                        let id = userData["_id"] as? String ?? ""
                        let user = User.findOrCreateUser(id: id, data: userData, in: PersistenceService.context)
                        users.append(user)
                    })
                }
                completion(feed, users)
            }
        }
    }
    
    static func fetchSavedTimeline(completion: @escaping ([Status]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            var feed = Status.fetchAll(in: PersistenceService.context)
            feed.sort { (s0, s1) -> Bool in
                s0.timestamp > s1.timestamp
            }
            completion(feed)
        }
    }
    
    static func fetchTimeline(cursor: Int, completion: @escaping ([Status]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let urlString = "\(baseUrl)/timeline"
            let url = URL(string: urlString)!
            let headers: HTTPHeaders = ["Authorization": "Bearer \(Model.shared.token)"]
            let params: [String:Any] = ["cursor":cursor]
            var feed: [Status] = []
            //feed = Status.fetchAll(in: PersistenceService.context)
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                guard let json = response.result.value as? [String:Any],
                    let resp = json["response"] as? [String:Any],
                    let results = resp["posts"] as? [[String:Any]] else { return
                        completion([])
                }
                results.forEach({ (result) in
                    guard let id = result["_id"] as? String else { return }
                    let status = Status.findOrCreateStatus(id: id, data: result, in: PersistenceService.context)
                    if !feed.contains(status), status.inReplyToId == nil {
                        feed.append(status)
                    }
                })
                let sorted = feed.sorted(by: { (s0, s1) -> Bool in
                    s0.timestamp > s1.timestamp
                })
                completion(sorted)
            }
        }
    }
    
    static func fetchMorePosts(cursor: Int, completion: @escaping ([Status]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let urlString = "\(baseUrl)/timeline"
            let url = URL(string: urlString)!
            let headers: HTTPHeaders = ["Authorization": "Bearer \(Model.shared.token)"]
            let params: [String:Any] = ["cursor":cursor]
            var feed: [Status] = []
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                guard let json = response.result.value as? [String:Any],
                    let resp = json["response"] as? [String:Any],
                    let results = resp["posts"] as? [[String:Any]] else { return
                        completion([])
                }
                results.forEach({ (result) in
                    let id = result["_id"] as? String ?? ""
                    let status = Status.findOrCreateStatus(id: id, data: result, in: PersistenceService.context)
                        feed.append(status)
                })
                completion(feed)
            }
        }
    }
    
    
    static func fetchPosts(cursor: Int, forUser userId: String, completion: @escaping ([Status]) -> Void) {
        let urlString = "\(baseUrl)/posts"
        let url = URL(string: urlString)!
        let token = Model.shared.token
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let params: [String:Any] = ["userId":userId, "cursor": cursor]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            var feed = [Status]()
            guard let json = response.result.value as? [String:Any],
                let resp = json["response"] as? [String:Any],
                let results = resp["posts"] as? [[String:Any]] else { return }
            results.forEach({ (result) in
                let id = result["_id"] as? String ?? ""
                let status = Status.findOrCreateStatus(id: id, data: result, in: PersistenceService.context)
                feed.append(status)
            })
            completion(feed)
        }
    }
    
    
    static func fetchPosts(forQuery query: String, completion: @escaping ([Status]?) -> Void) {
        let urlString = "\(baseUrl)/posts"
        let url = URL(string: urlString)!
        let token = Model.shared.token
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let params: [String:Any] = ["query":query]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            var feed = [Status]()
            guard let json = response.result.value as? [String:Any],
                let resp = json["response"] as? [String:Any],
                let results = resp["posts"] as? [[String:Any]] else {
                    completion([])
                    return
            }
            results.forEach({ (result) in
                let id = result["_id"] as? String ?? ""
                let status = Status.findOrCreateStatus(id: id, data: result, in: PersistenceService.context)
                feed.append(status)
            })
            completion(feed)
        }
    }
    
    static func fetchPost(postId: String, completion: @escaping (Status) -> Void) {
        let urlString = "\(baseUrl)/post"
        let url = URL(string: urlString)!
        let token = Model.shared.token
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let params: Parameters = ["postId":postId]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            guard let json = response.result.value as? [String:Any],
                let resp = json["response"] as? [String:Any],
                let data = resp["post"] as? [String:Any] else { return }
                let id = data["_id"] as? String ?? ""
                let status = Status.findOrCreateStatus(id: id, data: data, in: PersistenceService.context)
            completion(status)
        }
    }
    
    static func fetchReplies(statusId: String, completion: @escaping ([Status]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let urlString = "\(baseUrl)/replies"
            let url = URL(string: urlString)!
            let token = Model.shared.token
            let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
            let params: Parameters = ["postId":statusId]
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                var feed = [Status]()
                guard let json = response.result.value as? [String:Any],
                    let resp = json["response"] as? [String:Any],
                    let results = resp["posts"] as? [[String:Any]] else { return }
                results.forEach({ (result) in
                    let id = result["_id"] as? String ?? ""
                    let status = Status.findOrCreateStatus(id: id, data: result, in: PersistenceService.context)
                    feed.append(status)
                })
                completion(feed)
            }
        }
    }
    
    static func postStatus(inReplyTo: Status?, text: String, link: String?, linkImage: String?, linkTitle: String?, completion: ((Status) -> Void)? = nil) {
        let urlString = "\(baseUrl)/newpost"
        let url = URL(string: urlString)!
        let token = Model.shared.token
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        var params: Parameters = ["text":text]
        if link != nil { params["link"] = link! }
        if linkImage != nil { params["linkImage"] = linkImage! }
        if linkTitle != nil { params["linkTitle"] = linkTitle! }
        
        if let inReplyToId = inReplyTo?.id {
            params["inReplyToId"] = inReplyToId
            inReplyTo?.commentCount += Int16(exactly: 1)!
        }
        
        if let mentions = text.mentions { params["mentions"] = mentions }

        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            guard let json = response.result.value as? [String:Any],
                let resp = json["response"] as? [String:Any],
                let result = resp["post"] as? [String:Any] else { return }
            let id = result["_id"] as? String ?? ""
            let status = Status.findOrCreateStatus(id: id, data: result, in: PersistenceService.context)
            if inReplyTo == nil {
            NotificationCenter.default.post(name: Notification.Name("newPost"), object: nil, userInfo: ["status":status])
            }
            completion?(status)
        }
    }
    
    static func postStatusWithPhoto(text: String, image: UIImage) {
        let urlString = "\(baseUrl)/newpost"
        let url = URL(string: urlString)!
        let uuid = Model.shared.uuid
        let token = Model.shared.token
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        var params: Parameters = ["userId":uuid,"text":text]
        uploadImageToStorage(image: image) { (imageUrlString) in
            params["image"] = imageUrlString
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                guard let json = response.result.value as? [String:Any],
                    let resp = json["response"] as? [String:Any],
                    let result = resp["post"] as? [String:Any] else { return }
                let id = result["_id"] as? String ?? ""
                let status = Status.findOrCreateStatus(id: id, data: result, in: PersistenceService.context)
                NotificationCenter.default.post(name: Notification.Name("newPost"), object: nil, userInfo: ["status":status])
            }
        }
    }
    
    
    
    static func deletePost(postId: String, completion: @escaping (Bool) -> Void) {
        let urlString = "\(baseUrl)/delete"
        let url = URL(string: urlString)!
        let token = Model.shared.token
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let params: Parameters = ["postId":postId]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            guard let json = response.result.value as? [String:Any],
                let status = json["status"] as? String else { return }
            if status == "NOT_RUN" {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
    static func likePost(postId: String) {
        let like = Like.likePost(postId: postId, in: PersistenceService.context)
        let urlString = "\(baseUrl)/like"
        let url = URL(string: urlString)!
        let token = Model.shared.token
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let params: Parameters = ["postId":postId, "like":like.description]
        Model.shared.favorites[postId] = like
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
        }
    }
    
    static func fetchLikes() {
        let urlString = "\(baseUrl)/likes"
        let url = URL(string: urlString)!
        let token = Model.shared.token
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let params: [String:Any] = [:]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            
            guard let json = response.result.value as? [String:Any],
                let resp = json["response"] as? [String:Any],
                let likes = resp["likes"] as? [String] else { return }
            
            likes.forEach({ (id) in
                Model.shared.favorites[id] = true
            })
        }
    }
    
    
}


internal func uploadImageToStorage(image: UIImage, completion: @escaping (String) -> Swift.Void) {
    let imageName = UUID.init().uuidString
    let ref = Storage.storage().reference().child("images").child(imageName)
    if let uploadData = UIImageJPEGRepresentation(image, 0.5) {
        ref.putData(uploadData, metadata: nil, completion: { (metaData, error) in
            if error != nil {
                print("failed to upload image:", error!)
                return
            }
            ref.downloadURL(completion: { (url, err) in
                if let link = url?.absoluteString {
                    completion(link)
                }
            })
        })
    }
}

internal func convertImageToBase64(image: UIImage) -> String {
    let imageData = UIImagePNGRepresentation(image)!
    let base64 = imageData.base64EncodedString()
    return base64
}


