//
//  ViewController.swift
//  Sparrow
//
//  Created by Hackr on 7/27/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import SimpleImageViewer

class UserController: UITableViewController, UserHeaderDelegate, StatusCellDelegate {
    
    private let refresh = UIRefreshControl()
    private var spinner: UIActivityIndicatorView!
    private let statusCell = "statusCell"
    
    var following: Bool = false {
        didSet {
            self.header.following = following
        }
    }
    
    var user: User? {
        didSet {
            header.user = user
            adjustHeaderHeight()
            fetchPosts()
        }
    }
    
    func adjustHeaderHeight() {
        if let text = user?.bio {
            let textHeight = estimateFrameForText(width: self.view.frame.width-32, text: text, fontSize: 18).height
            header.frame.size.height += textHeight
        }
    }
    
    convenience init(userId: String) {
        self.init(style: .grouped)
        UserService.fetchUser(uuid: userId) { (user, following) in
            self.user = user
            self.following = following
        }
    }
    
    convenience init(username: String) {
        self.init(style: .grouped)
        UserService.fetchUser(username: username) { (user, following) in
            self.user = user
            self.following = following
        }
    }
    
    var timeline = [Status]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
                self.refresh.endRefreshing()
            }
        }
    }
    
    var header: UserHeader = {
        let header = UserHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 180))
        return header
    }() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.darkBackground
        tableView.register(StatusCell.self, forCellReuseIdentifier: statusCell)
        tableView.tableHeaderView = header
        tableView.backgroundColor = Theme.darkBackground
        tableView.separatorColor = Theme.border
        tableView.separatorInset = UIEdgeInsets.zero
        header.delegate = self
        navigationItem.title = "User"
        let plusIcon = UIImage(named: "compose")?.withRenderingMode(.alwaysTemplate)
        let plus = UIBarButtonItem(image: plusIcon, style: .done, target: self, action: #selector(handleCompose))
        navigationItem.rightBarButtonItem = plus
        plus.tintColor = Theme.white
        extendedLayoutIncludesOpaqueBars = true
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80)
        spinner.tintColor = Theme.lightGray
        tableView.tableFooterView = spinner
        spinner.startAnimating()
    }
    
    @objc func handleCompose() {
        let username = user?.username ?? ""
        let vc = ComposeController(username)
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.refreshControl = refresh
        refresh.tintColor = Theme.lightGray
        refresh.addTarget(self, action: #selector(fetchPosts), for: .valueChanged)
    }
    
    @objc func fetchPosts() {
        allPostsLoaded = false
        guard let uuid = user?.id else { return }
        NewsService.fetchPosts(cursor: 0, forUser: uuid) { [weak self] (feed) in
            self?.timeline = feed
            self?.spinner.stopAnimating()
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: statusCell, for: indexPath) as! StatusCell
        cell.delegate = self
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
        guard allPostsLoaded == false,
            loadingPosts == false,
        let userId = user?.id else { return }
        loadingPosts = true
        self.spinner.startAnimating()
        NewsService.fetchPosts(cursor: timeline.count+1, forUser: userId) { [weak self] (feed) in
            self?.spinner.stopAnimating()
            self?.loadingPosts = false
            guard feed.count > 0 else {
                self?.allPostsLoaded = true
                return
            }
            self?.timeline.append(contentsOf: feed)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return timeline[indexPath.row].height(withReply: true)
    }
    
    
    func handleFollow() {
        guard let id = user?.id else { return }
        guard following == false else {
            presentUnfollowAlert()
            return
        }
        UserService.follow(userId: id, follow: !following) { (following) in
            self.following = following
        }
    }
    
    func presentUnfollowAlert() {
        guard let id = user?.id else { return }
        let username = user?.username ?? ""
        let alert = UIAlertController(title: "@\(username)", message: nil, preferredStyle: .actionSheet)
        let unfollow = UIAlertAction(title: "Unfollow", style: .destructive) { (_) in
            UserService.follow(userId: id, follow: !self.following) { (following) in
                self.following = following
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(unfollow)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func handlePay() {
        guard let pk = user?.publicKey else { return }
        guard KeychainHelper.privateSeed != "" else {
            presentRecoveryController()
            return
        }
        let vc = AmountController(publicKey: pk)
        vc.username = user?.username
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = StatusController(style: .plain)
        vc.status = timeline[indexPath.row]
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
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
    
    func handleUserTap(userId: String) {}
    
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

    func handleReplyTap(inReplyToId: String) {
        let vc = StatusController(statusId: inReplyToId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentRecoveryController() {
        let vc = RecoveryController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
}
