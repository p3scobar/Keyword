//
//  BlockedUsersController.swift
//  Sparrow
//
//  Created by Hackr on 8/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import UIKit
import Firebase

class BlockedUsersController: UITableViewController {
    
    let userCellSmall = "userCellSmall"
    var searchController: UISearchController!
    
    var isFiltering: Bool = false
    
    var users = [User]() {
        didSet {
            reloadTable()
        }
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserCell.self, forCellReuseIdentifier: userCellSmall)
        title = "Blocked Users"
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0, 100, 0, 0)
        fetchData()
    }
    
    
    @objc func fetchData() {
        users.removeAll()
        let blockedIds = Model.shared.blocked ?? [:]
        for (key, value) in blockedIds {
            if value == true {
//                UserManager.fetchUser(userId: key, completion: { (user) in
//                    self.users.append(user)
//                })
            }
        }
        self.refreshControl?.endRefreshing()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellSmall, for: indexPath) as! UserCell
        cell.profileImage.image = nil
        let user = self.users[indexPath.row]
        cell.user = user
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.item]
        let vc = UserController()
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

