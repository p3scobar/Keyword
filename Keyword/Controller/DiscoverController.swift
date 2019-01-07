//
//  DiscoverController.swift
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

class DiscoverController: CoreDataTableViewController, UISearchBarDelegate, UINavigationBarDelegate, StatusCellDelegate, UITabBarControllerDelegate {
    
    private let statusCell = "newsCell"
    private let userCell = "userCell"
    
    private let refresh = UIRefreshControl()
    var searchController: UISearchController!
    var spinner: UIActivityIndicatorView!
    
    var timeline = [Status]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refresh.endRefreshing()
            }
        }
    }
    
    var users = [User]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refresh.endRefreshing()
            }
        }
    }
    
    var scrollEnabled: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.darkBackground
        tableView.backgroundColor = Theme.darkBackground
        tableView.register(StatusCell.self, forCellReuseIdentifier: statusCell)
        tableView.register(UserCell.self, forCellReuseIdentifier: userCell)
        tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.separatorColor = Theme.border
        
        definesPresentationContext = true
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80)
        spinner.tintColor = Theme.lightGray
        spinner.startAnimating()
        tableView.tableFooterView = spinner
        
        let vc = ResultsController(style: .plain)
        vc.navController = self.navigationController
        
        searchController = UISearchController(searchResultsController: vc)
        vc.searchController = searchController
        
        searchController.searchResultsUpdater = vc
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.layer.cornerRadius = 20
        searchController.searchBar.clipsToBounds = true
        searchController.searchBar.barTintColor = Theme.tintColor
        searchController.searchBar.tintColor = Theme.white
        
        extendedLayoutIncludesOpaqueBars = true

        navigationItem.titleView = searchController.searchBar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.keyboardAppearance = .dark
        tableView.keyboardDismissMode = .interactive
        fetchData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        scrollEnabled = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.shadowImage = nil
        refresh.endRefreshing()
    }
    
    @objc func handleCompose() {
        let vc = ComposeController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        scrollEnabled = true
    }

    
    func scrollToTop() {
        if scrollEnabled && timeline.count > 0 {
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
        allPostsLoaded = false
        NewsService.discover(cursor: 0) { [weak self] (feed, users) in
            self?.timeline = feed
            self?.users = users
            self?.spinner.stopAnimating()
        }
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return users.count
        } else {
            return timeline.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        checkIfScrolledToBottom(indexPath)
        let background = UIView()
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath) as! UserCell
            cell.user = users[indexPath.row]
            background.backgroundColor = Theme.darkBackground
            cell.selectedBackgroundView = background
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: statusCell, for: indexPath) as! StatusCell
            cell.delegate = self
            cell.indexPath = indexPath
            cell.status = timeline[indexPath.row]
            background.backgroundColor = Theme.darkBackground
            cell.selectedBackgroundView = background
            return cell
        }
    }
    
    
    func checkIfScrolledToBottom(_ indexPath: IndexPath) {
        guard Model.shared.uuid != "",
            indexPath.row == timeline.count-5,
            indexPath.row > 2,
            timeline.count > 0 else { return }
        loadMorePosts()
    }
    
    var allPostsLoaded: Bool = false
    var loadingPosts: Bool = false
    
    func loadMorePosts() {
        guard allPostsLoaded == false, loadingPosts == false else { return }
        loadingPosts = true
        self.spinner.startAnimating()
        NewsService.discover(cursor: timeline.count+1) { [weak self] (posts, _) in
            self?.loadingPosts = false
            self?.spinner.stopAnimating()
            guard posts.count > 0 else {
                self?.allPostsLoaded = true
                return
            }
            self?.timeline.append(contentsOf: posts)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            var height: CGFloat = 72
            if let bio = users[indexPath.row].bio {
                let textHeight = bio.height(forWidth: view.frame.width-84, font: Theme.medium(18))
                height += textHeight+10
            }
            return height
        } else {
            return timeline[indexPath.row].height(withReply: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        } else {
            return timeline[indexPath.row].height(withReply: true)
        }
    }
    
    
    func handleLike(postId: String) {
        NewsService.likePost(postId: postId)
    }
    
    
    func handleComment(status: Status) {
        let vc = StatusController(style: .plain)
        vc.status = status
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    func handleUserTap(userId: String) {
        let vc = UserController(userId: userId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            pushUserController(indexPath)
        } else {
            pushStatusController(indexPath)
        }
    }
    
    func pushUserController(_ indexPath: IndexPath) {
        let vc = UserController(userId: users[indexPath.row].id ?? "")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushStatusController(_ indexPath: IndexPath) {
        let vc = StatusController(style: .plain)
        vc.status = timeline[indexPath.row]
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
//    func handleReplyTap(replyToId: String) {
//        let vc = StatusController(statusId: replyToId)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    func handleLinkTap(url: URL) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        config.barCollapsingEnabled = true
        let vc = SFSafariViewController(url: url, configuration: config)
        present(vc, animated: true, completion: nil)
    }
    
    func handleMentionTap(_ username: String) {
        let vc = UserController(username: username)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleHashtagTap(_ hashtag: String) {
        let vc = HashtagController(hashtag: hashtag)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! TableHeaderView
        if section == 0 {
            cell.titleLabel.text = "People"
        } else {
            cell.titleLabel.text = "Trending"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 28
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let query = searchController.searchBar.text ?? ""
//        let vc = SwipeController(query: query)
//        self.navigationController?.pushViewController(vc, animated: true)
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

