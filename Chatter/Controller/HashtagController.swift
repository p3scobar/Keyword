//
//  DiscoverPostsController.swift
//  Chatter
//
//  Created by Hackr on 8/22/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import CoreData
import SimpleImageViewer

class HashtagController: UITableViewController, UISearchControllerDelegate, UINavigationBarDelegate, StatusCellDelegate, UITabBarControllerDelegate {
    
    var navController: UINavigationController?
    
    private let statusCell = "newsCell"
    private let refresh = UIRefreshControl()
    
    var timeline = [Status]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refresh.endRefreshing()
            }
        }
    }
    
    var tabBarIndex: Int = 0
    var scrollEnabled: Bool = false
    
    var queryString: String? {
        didSet {
            fetchData()
        }
    }

    convenience init(hashtag: String) {
        self.init(style: .grouped)
        self.navigationItem.title = "#\(hashtag)"
        queryString = hashtag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = Theme.darkBackground
        tableView.register(StatusCell.self, forCellReuseIdentifier: statusCell)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.separatorColor = Theme.border
        fetchData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.refreshControl = refresh
        refresh.tintColor = .black
        refresh.addTarget(self, action: #selector(fetchData), for: .valueChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        scrollEnabled = false
    }
    
    func scrollToTop() {
        if tabBarIndex == 0 && scrollEnabled && timeline.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
  
    func presentHomeController() {
        let vc = HomeController()
        let nav = UINavigationController(rootViewController: vc)
        self.tabBarController?.present(nav, animated: false, completion: nil)
    }
    
    @objc func fetchData() {
        let query = queryString ?? ""
        NewsService.fetchPosts(forQuery: query) { (feed) in
            if feed != nil {
                self.timeline = feed!
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: statusCell, for: indexPath) as! StatusCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.status = timeline[indexPath.row]
        let background = UIView()
        background.backgroundColor = Theme.darkBackground
        cell.selectedBackgroundView = background
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return timeline[indexPath.row].height(withReply: true)
    }
    
    
    func handleLike(postId: String, like: Bool) {
        NewsService.likePost(postId: postId, like: like)
    }
    
    
    func handleComment(status: Status) {
        let vc = StatusController(style: .plain)
        vc.status = status
        self.hidesBottomBarWhenPushed = true
        let nav = self.navigationController ?? navController
        nav?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    func handleUserTap(userId: String) {
        let vc = UserController(userId: userId)
        let nav = self.navigationController ?? navController
        nav?.pushViewController(vc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = StatusController(style: .plain)
        vc.status = timeline[indexPath.row]
        self.hidesBottomBarWhenPushed = true
        let nav = self.navigationController ?? navController
        nav?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    
    func handleLinkTap(url: URL) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        config.barCollapsingEnabled = true
        let vc = SFSafariViewController(url: url, configuration: config)
        present(vc, animated: true, completion: nil)
    }
    
    func handleMentionTap(_ username: String) {
        let vc = UserController(username: username)
        let nav = self.navigationController ?? navController
        nav?.pushViewController(vc, animated: true)
    }
    
    func handleHashtagTap(_ hashtag: String) {
        let vc = HashtagController(hashtag: hashtag)
        let nav = self.navigationController ?? navController
        nav?.pushViewController(vc, animated: true)
    }
    
    func handleImageTap(imageView: UIImageView) {
        let configuration = ImageViewerConfiguration { config in
            config.imageView = imageView
        }
        present(ImageViewerController(configuration: configuration), animated: true)
    }
    
    func handleReplyTap(inReplyToId: String) {
        let vc = StatusController(statusId: inReplyToId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
