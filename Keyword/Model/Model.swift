//
//  Model.swift
//  Sparrow
//
//  Created by Hackr on 8/2/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import Foundation
import UIKit
import Alamofire
import Firebase

class Model {
    
//    var notifications = [Activity]()
//    var notificationAdded: ((Activity) -> Void)?
//    var notificationRead: ((String) -> Void)?
    var favorites: [String:Bool] = [:]
    
    static let shared: Model = Model()
    
    var token: String {
        get { return UserDefaults.standard.string(forKey: "token") ?? "" }
        set (token) { UserDefaults.standard.setValue(token, forKey: "token") }
    }
    
    var uuid: String {
        get { return UserDefaults.standard.string(forKey: "userId") ?? "" }
        set (uid) { UserDefaults.standard.setValue(uid, forKey: "userId") }
    }
    
    var email: String {
        get { return UserDefaults.standard.string(forKey: "email") ?? "" }
        set (param) { UserDefaults.standard.setValue(param, forKey: "email") }
    }
    
    var name: String {
        get { return UserDefaults.standard.string(forKey: "name") ?? "" }
        set (param) { UserDefaults.standard.setValue(param, forKey: "name") }
    }
    
    var username: String {
        get { return UserDefaults.standard.string(forKey: "username") ?? "" }
        set (param) { UserDefaults.standard.setValue(param, forKey: "username") }
    }
    
    var profileImage: String {
        get { return UserDefaults.standard.string(forKey: "profileImage") ?? "" }
        set (param) { UserDefaults.standard.setValue(param, forKey: "profileImage") }
    }
    
    var bio: String {
        get { return UserDefaults.standard.string(forKey: "bio") ?? "" }
        set (param) { UserDefaults.standard.setValue(param, forKey: "bio") }
    }
    
    var soundsEnabled: Bool {
        get { return UserDefaults.standard.bool(forKey: "soundEnabled") }
        set (enabled) { UserDefaults.standard.set(enabled, forKey: "soundEnabled") }
    }

    
    var blocked: [String:Bool]?
    
    init() {}
    
    static func fetchCurrentUser() {
        
    }
    
    
}
