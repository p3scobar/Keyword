//
//  UsersController.swift
//  Chatter
//
//  Created by Hackr on 8/8/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import Foundation
import UIKit
import SafariServices
import CoreData


class UsersController: UITableViewController, UISearchControllerDelegate, UINavigationBarDelegate {
    
    var navController: UINavigationController?
    
    var queryString: String? {
        didSet {
            fetchData()
        }
    }
    
    private let userCell = "userCell"
    private let refresh = UIRefreshControl()
    var searchController: UISearchController!
    
    
    var users = [User]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refresh.endRefreshing()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserCell.self, forCellReuseIdentifier: userCell)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = Theme.lightBackground
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        navigationItem.title = "Discover"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.definesPresentationContext = true
        let vc = SwipeController()
        
        searchController = UISearchController(searchResultsController: vc)
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.tintColor = Theme.gray
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        fetchData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.refreshControl = refresh
        refresh.tintColor = .black
        refresh.addTarget(self, action: #selector(fetchData), for: .valueChanged)
    }
    
    
    @objc func fetchData() {
        let query = queryString ?? ""
        UserService.discoverUsers(query: query) { (users) in
            self.users = users
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
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 88
        if let bio = users[indexPath.row].bio {
            let textHeight = bio.height(forWidth: view.frame.width-92, font: Theme.medium(18))
            height += textHeight
        }
        return height
    }
    
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let uuid = users[indexPath.row].id else { return }
        let vc = UserController(userId: uuid)
        let nav = self.navigationController ?? navController
        nav?.pushViewController(vc, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }

    
}

