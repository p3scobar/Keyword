//
//  ActivityController.swift
//  Sparrow
//
//  Created by Hackr on 7/28/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import CoreData

class ActivityController: UITableViewController, UISearchControllerDelegate, UINavigationBarDelegate, CommentCellDelegate {

    private let activityCell = "activityCell"
    private let refresh = UIRefreshControl()
    
//    var tabBarIndex: Int = 2
    var scrollEnabled: Bool = false
    
    var notifications = [Activity]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refresh.endRefreshing()
                self.setupEmptyView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.separatorColor = Theme.border
        tableView.backgroundColor = Theme.darkBackground
        tableView.register(ActivityCell.self, forCellReuseIdentifier: activityCell)
        navigationItem.title = "Activity"
        navigationController?.navigationBar.prefersLargeTitles = true
        extendedLayoutIncludesOpaqueBars = true
        fetchData()
    }
    
    func scrollToTop() {
        if scrollEnabled && notifications.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    @objc func fetchData() {
        ActivityService.fetchActivity { (notifications) in
            self.notifications = notifications
            self.markAllAsRead()
        }
    }
    
    func markAllAsRead() {
        ActivityService.markAllRead { (success) in
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollEnabled = true
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(fetchData), for: .valueChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        scrollEnabled = false
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    let background = UIView()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: activityCell, for: indexPath) as! ActivityCell
        cell.delegate = self
        background.backgroundColor = Theme.darkBackground
        cell.selectedBackgroundView = background
        cell.activity = notifications[indexPath.row]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 60
        if let text = notifications[indexPath.row].text {
            let textHeight = estimateFrameForTextWidth(width: view.frame.width-84, text: text, fontSize: 18)
            height += (textHeight <= 36) ? textHeight : 36
        }
        return height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let activity = notifications[indexPath.row]
        guard let type = activity.type else { return }
        if type == "follow" {
            guard let userId = activity.userId else { return }
            pushUserController(userId)
        } else {
            guard let statusId = activity.statusId else { return }
            pushStatusController(statusId)
        }
    }
    
    func pushStatusController(_ statusId: String) {
        let vc = StatusController(statusId: statusId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushUserController(_ userId: String) {
        let vc = UserController(userId: userId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleUserTap(userId: String) {
        let vc = UserController(userId: userId)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    lazy var emptyLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: 80))
        label.text = "No activity yet."
        label.textColor = Theme.gray
        label.font = Theme.semibold(18)
        label.textAlignment = .center
        return label
    }()
    
    func setupEmptyView() {
        if notifications.count == 0 {
            self.tableView.backgroundView = emptyLabel
        } else {
            self.tableView.backgroundView = nil
        }
    }
    
    
}


