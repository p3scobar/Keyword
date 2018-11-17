//
//  UserService.swift
//  Sparrow
//
//  Created by Hackr on 8/2/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import Alamofire
import stellarsdk

struct UserService {
    
    static func follow(userId: String, follow: Bool, completion: @escaping (Bool) -> Void) {
        let urlString = "\(baseUrl)/follow"
        let url = URL(string: urlString)!
        let token = Model.shared.token
        let header: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        let params: Parameters = ["userId":userId, "follow": follow.description]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
            guard let json = response.result.value as? [String:Any],
                let resp = json["response"] as? [String:Any] else { return }

            let following = resp["following"] as? Bool ?? false
            print("Following on UserService.follow: \(following)")
            completion(following)
        }
    }
    
    static func fetchUsers(username: String, completion: @escaping ([User]) -> Void) {
        let urlString = "\(baseUrl)/users"
        let url = URL(string: urlString)!
        let params: [String:Any] = ["text":username]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            var users = [User]()
            guard let json = response.result.value as? [String:Any],
                let resp = json["response"] as? [String:Any],
                let results = resp["users"] as? [[String:Any]] else { return }
            results.forEach({ (data) in
                let id = data["_id"] as? String ?? ""
                let user = User.findOrCreateUser(id: id, data: data, in: PersistenceService.context)
                users.append(user)
            })
            completion(users)
        }
    }
    
    static func discoverUsers(query: String, completion: @escaping ([User]) -> Void) {
        let urlString = "\(baseUrl)/users"
        let url = URL(string: urlString)!
        let token = Model.shared.token
        let headers: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        let params: [String:Any] = ["text":query]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            var users = [User]()
            guard let json = response.result.value as? [String:Any],
                let resp = json["response"] as? [String:Any],
                let results = resp["users"] as? [[String:Any]] else { return }
            results.forEach({ (data) in
                let id = data["_id"] as? String ?? ""
                let user = User.findOrCreateUser(id: id, data: data, in: PersistenceService.context)
                users.append(user)
            })
            completion(users)
        }
    }
    
    static func fetchUser(uuid: String, completion: @escaping (User, Bool) -> Void) {
        let urlString = "\(baseUrl)/user"
        let url = URL(string: urlString)!
        let token = Model.shared.token
        let headers: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        let params: [String:Any] = ["userId":uuid]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            guard let json = response.result.value as? [String:Any],
                let resp = json["response"] as? [String:Any],
                let result = resp["user"] as? [String:Any] else { return }
            
            let following: Bool = resp["following"] as? Bool ?? false
            let id = result["_id"] as? String ?? ""
            let user = User.findOrCreateUser(id: id, data: result, in: PersistenceService.context)
            completion(user, following)
        }
    }
    
    static func fetchUser(username: String, completion: @escaping (User, Bool) -> Void) {
        let urlString = "\(baseUrl)/user"
        let url = URL(string: urlString)!
        let token = Model.shared.token
        let headers: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        let params: [String:Any] = ["username":username]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            guard let json = response.result.value as? [String:Any],
                let resp = json["response"] as? [String:Any],
                let result = resp["user"] as? [String:Any] else { return }
            
            let following: Bool = resp["following"] as? Bool ?? false
            guard let id = result["_id"] as? String else { return }
            let user = User.findOrCreateUser(id: id, data: result, in: PersistenceService.context)
            completion(user, following)
        }
    }
    
    
    static func signup(name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        let urlString = "\(baseUrl)/signup"
        let url = URL(string: urlString)!
        let params: [String:Any] = ["name":name, "email":email, "password":password]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard let json = response.result.value as? [String:Any],
                let resp = json["response"] as? [String:Any],
                let userData = resp["user"] as? [String:Any] else { return }
            let token = resp["token"] as? String ?? ""
            let id = userData["_id"] as? String ?? ""
            let user = User.findOrCreateUser(id: id, data: userData, in: PersistenceService.context)
            Model.shared.token = token
            Model.shared.uuid = user.id ?? ""
            Model.shared.name = user.name ?? ""
            Model.shared.email = email
            Model.shared.username = user.username ?? ""
            Model.shared.bio = user.bio ?? ""
            KeychainHelper.mnemonic = Wallet.generate12WordMnemonic()
            completion(true)
        }
    }
    
    
    static func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let urlString = "\(baseUrl)/login"
        let url = URL(string: urlString)!
        let params: [String:Any] = ["email":email, "password":password]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
            guard let json = response.result.value as? [String:Any],
                let resp = json["response"] as? [String:Any],
                let userData = resp["user"] as? [String:Any] else { return }
            let id = userData["_id"] as? String ?? ""
            let user = User.findOrCreateUser(id: id, data: userData, in: PersistenceService.context)
            let token = resp["token"] as? String ?? ""
            Model.shared.token = token
            Model.shared.uuid = user.id ?? ""
            Model.shared.name = user.name ?? ""
            Model.shared.username = user.username ?? ""
            Model.shared.profileImage = user.image ?? ""
            Model.shared.bio = user.bio ?? ""
            KeychainHelper.publicKey = user.publicKey ?? ""
            if let _ = response.error {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    static func signout(completion: @escaping (Bool) -> Void) {
        let urlString = "\(baseUrl)/signout"
        let url = URL(string: urlString)!
        let token = Model.shared.token
        let headers: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        let params: [String:Any] = [:]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            Model.shared.uuid = ""
            Model.shared.name = ""
            Model.shared.username = ""
            Model.shared.profileImage = ""
            Model.shared.bio = ""
            Model.shared.token = ""
            KeychainHelper.publicKey = ""
            KeychainHelper.privateSeed = ""
            KeychainHelper.mnemonic = ""
            completion(true)
        }
    }
    
    static func updateUsername(username: String, completion: @escaping (Bool) -> Void) {
        let urlString = "\(baseUrl)/username"
        let url = URL(string: urlString)!
        let token = Model.shared.token
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let params: [String:Any] = ["username":username]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            guard let json = response.result.value as? [String:Any],
                let resp = json["response"] as? [String:Any],
                let username = resp["username"] as? String else {
                    completion(false)
                    return
            }
            Model.shared.username = username
            completion(true)
        }
    }

    
    static func updatePublicKey(pk: String, completion: @escaping (Bool) -> Void) {
        let urlString = "\(baseUrl)/publickey"
        let url = URL(string: urlString)!
        let token = Model.shared.token
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let params: [String:Any] = ["key":pk]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if let error = response.error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
    static func updateUser(name: String, bio: String, completion: @escaping (Bool) -> Void) {
        let urlString = "\(baseUrl)/updateuser"
        let url = URL(string: urlString)!
        let token = Model.shared.token
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let params: [String:Any] = ["name":name, "bio":bio]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if let error = response.error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
    static func updateProfilePic(image: UIImage, completion: @escaping (String) -> Void) {
        uploadImageToStorage(image: image) { (imageUrl) in
            let urlString = "\(baseUrl)/profile"
            let url = URL(string: urlString)!
            let token = Model.shared.token
            let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
            let params: [String:Any] = ["image":imageUrl]
            
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                if let error = response.error {
                    print(error.localizedDescription)
                    completion("")
                } else {
                    completion(imageUrl)
                }
            }
        }
    }
    
    
}
