//
//  FollowController.swift
//  Chatter
//
//  Created by Hackr on 11/23/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit

class FollowController: UITableViewController, UserCellDelegate {
    
    let userCell = "userCell"
    
    var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var continueButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "People to Follow"
        view.backgroundColor = Theme.darkBackground
        tableView.backgroundColor = Theme.darkBackground
        tableView.separatorColor = Theme.border
        tableView.register(UserCell.self, forCellReuseIdentifier: userCell)
        tableView.allowsSelection = false
        continueButton = UIBarButtonItem(title: "Skip", style: .done, target: self, action: #selector(handleContinue))
        continueButton.tintColor = UIColor.white.withAlphaComponent(0.5)
        navigationItem.rightBarButtonItem = continueButton
        fetchUsers()
    }
    
    @objc func handleContinue() {
        if usersToFollow.count > 0 {
            UserService.followUsers(userIds: usersToFollow)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func fetchUsers() {
        UserService.suggestedUsers { (users) in
            self.users = users.filter({ $0.id != Model.shared.uuid })
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        cell.followButton.isHidden = false
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return users[indexPath.row].height()
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    

    func handleFollowButtonTap(userId: String) {
        if !usersToFollow.contains(userId) {
            usersToFollow.append(userId)
        } else {
            usersToFollow = usersToFollow.filter({ $0 != userId })
        }
        print(usersToFollow)
    }
    
    var usersToFollow: [String] = [] {
        didSet {
            if usersToFollow.count > 0 {
                continueButton.title = "Continue"
                continueButton.tintColor = UIColor.white
            } else {
                continueButton.title = "Skip"
                continueButton.tintColor = UIColor.white.withAlphaComponent(0.5)
            }
        }
    }
    
}
