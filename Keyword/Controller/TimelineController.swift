//
//  FeedController.swift
//  Sparrow
//
//  Created by Hackr on 7/27/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import Foundation
import UIKit
import SafariServices
import CoreData
import SimpleImageViewer

class TimelineController: CoreDataTableViewController, UISearchControllerDelegate, UINavigationBarDelegate, StatusCellDelegate, UITabBarControllerDelegate {
    
    private let statusCell = "newsCell"
    private var refresh = UIRefreshControl()
    private var spinner: UIActivityIndicatorView!
    
    var timeline = [Status]() {
        didSet {
            DispatchQueue.main.async {
                self.refresh.endRefreshing()
                self.tableView.reloadData()
                self.setupEmptyView()
            }
        }
    }
    
    var scrollEnabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StatusCell.self, forCellReuseIdentifier: statusCell)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.separatorColor = Theme.border
        tableView.backgroundColor = Theme.darkBackground
        navigationItem.title = "Today"
        tableView.contentInsetAdjustmentBehavior = .automatic
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80)
        spinner.tintColor = Theme.lightGray
        tableView.tableFooterView = spinner
        
        let plusIcon = UIImage(named: "compose")?.withRenderingMode(.alwaysTemplate)
        let plus = UIBarButtonItem(image: plusIcon, style: .done, target: self, action: #selector(handleCompose))
        plus.tintColor = Theme.highlight
        self.navigationItem.rightBarButtonItem = plus
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogin(notification:)), name: Notification.Name("login"), object: nil)
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(fetchData(_:)), for: .valueChanged)
        extendedLayoutIncludesOpaqueBars = true
        checkAuthentication()
    }
    
    @objc func presentFollowController() {
        let vc = FollowController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleLogin(notification:Notification) {
        fetchData(nil)
    }
    
    @objc func handleCompose() {
        let vc = ComposeController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        refresh.endRefreshing()
        scrollEnabled = false
    }
    
    func scrollToTop() {
        if scrollEnabled && timeline.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    
    func checkAuthentication() {
        guard Model.shared.uuid != "" else {
            presentHomeController()
            return
        }
        fetchData(nil)
        NewsService.fetchLikes()
        NotificationCenter.default.addObserver(self, selector: #selector(newPostUploaded(notification:)), name: Notification.Name("newPost"), object: nil)
    }
    
    @objc func newPostUploaded(notification: Notification) {
        scrollToTop()
        guard let status = notification.userInfo?["status"] as? Status else {
            print("failed to fetch status object in notification")
            return
        }
        self.timeline.insert(status, at: 0)
        tableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .top)
    }
    
    func presentHomeController() {
        let vc = HomeController()
        let nav = UINavigationController(rootViewController: vc)
        self.tabBarController?.present(nav, animated: false, completion: nil)
    }

    @objc func fetchData(_ sender: UIRefreshControl?) {
        allPostsLoaded = false
//        NewsService.fetchSavedTimeline { [weak self] (posts) in
//            self?.timeline = posts
//        }
        NewsService.fetchTimeline(cursor: 0) { [weak self] (feed) in
            self?.timeline = feed
            self?.printStats()
        }
    }
    
    func printStats() {
        let context = PersistenceService.context
        if let statusCount = (try? context.fetch(Status.fetchRequest()))?.count {
            print("STATUS COUNT: \(statusCount)")
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
        checkIfScrolledToBottom(indexPath)
        return cell
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
        NewsService.fetchMorePosts(cursor: timeline.count+1) { [weak self] feed in
            self?.spinner.stopAnimating()
            self?.loadingPosts = false
            guard feed.count > 0 else {
                self?.allPostsLoaded = true
                return
            }
            self?.timeline.append(contentsOf: feed)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return timeline[indexPath.row].height(withReply: true)
    }
    
    func handleLike(postId: String) {
        NewsService.likePost(postId: postId)
    }
    
    func handleComment(status: Status) {
        let vc = ComposeController(inReplyTo: status)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func handleUserTap(userId: String) {
        let vc = UserController(userId: userId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = StatusController(style: .plain)
        vc.status = timeline[indexPath.row]
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    func handleReplyTap(inReplyToId: String) {
        let vc = StatusController(statusId: inReplyToId)
        self.navigationController?.pushViewController(vc, animated: true)
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleHashtagTap(_ hashtag: String) {
        let vc = HashtagController(hashtag: hashtag)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleImageTap(imageView: UIImageView) {
        let configuration = ImageViewerConfiguration { config in
            config.imageView = imageView
        }
        present(ImageViewerController(configuration: configuration), animated: true)
    }
    
    func handleReplyTap(status: Status) {
        let vc = StatusController()
        vc.status = status
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return timeline[indexPath.row].height(withReply: true)
    }
    
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: 80))
        label.text = "Follow some folks!"
        label.textColor = Theme.gray
        label.font = Theme.semibold(18)
        label.textAlignment = .center
        return label
    }()
    
    func setupEmptyView() {
        if timeline.count == 0 {
            self.tableView.backgroundView = emptyLabel
        } else {
            self.tableView.backgroundView = nil
        }
    }
}

