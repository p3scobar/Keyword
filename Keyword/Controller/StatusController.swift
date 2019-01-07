//
//  StatusController.swift
//  Sparrow
//
//  Created by Hackr on 7/28/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import CoreData
import SimpleImageViewer

class StatusController: UITableViewController, UINavigationBarDelegate, StatusCellDelegate, StatusInputDelegate {
    
    private let statusCell = "newsCell"
    private let statusCellLarge = "statusCellLarge"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StatusCell.self, forCellReuseIdentifier: statusCell)
        tableView.register(StatusCellLarge.self, forCellReuseIdentifier: statusCellLarge)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        let more = UIImage(named: "more")?.withRenderingMode(.alwaysTemplate)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: more, style: .done, target: self, action: #selector(handleMore))
        navigationItem.title = "Status"
        tableView.keyboardDismissMode = .interactive
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = Theme.darkBackground
        tableView.backgroundColor = Theme.darkBackground
        tableView.separatorColor = Theme.border
    }
    
    var statusId: String?
    
    var status: Status? {
        didSet {
            fetchReplies()

        }
    }
    
    var replies: [Status] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    convenience init(statusId: String) {
        self.init()
        self.statusId = statusId
        fetchStatusFromId()
    }

    func fetchStatusFromId() {
        guard let id = statusId else { return }
        NewsService.fetchPost(postId: id) { (status) in
            self.status = status
        }
    }
    
    func fetchReplies() {
        guard let id = status?.id else { return }
        NewsService.fetchReplies(statusId: id) { (replies) in
            self.replies = replies
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return replies.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let background = UIView()
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: statusCellLarge, for: indexPath) as! StatusCellLarge
            cell.delegate = self
            cell.indexPath = indexPath
            cell.status = status
            cell.bottomLine.isHidden = false
//            cell.like = isFavorited(id: cell.status?.id ?? "")
            cell.selectionStyle = .none
            background.backgroundColor = Theme.darkBackground
            cell.selectedBackgroundView = background
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: statusCell, for: indexPath) as! StatusCell
            cell.delegate = self
            cell.status = replies[indexPath.row]
            cell.like = Like.checkIfLiked(postId: replies[indexPath.row].id)
            cell.replyView.isHidden = true
            background.backgroundColor = Theme.darkBackground
            cell.selectedBackgroundView = background
            return cell
        }
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return status?.heightLarge() ?? 0
        } else {
            return replies[indexPath.row].height(withReply: false)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let vc = StatusController(style: .plain)
            vc.status = replies[indexPath.row]
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            self.hidesBottomBarWhenPushed = false
        }
    }


    lazy var menu: StatusInputView = {
        let view = StatusInputView()
        view.replyDelegate = self
        return view
    }()


    override var inputAccessoryView: UIView! {
        get {
            return menu
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }


    @objc func handleSend() {
        guard let text = menu.inputTextField.textView.text,
            text.count > 0 else { return }
        NewsService.postStatus(inReplyTo: status, text: text, link: nil, linkImage: nil, linkTitle: nil) { (status) in
            self.replies.insert(status, at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .left)
        }
        menu.inputTextField.textView.text = ""
        menu.inputTextField.textView.resignFirstResponder()
    }

    func handleComment(status: Status) {
        if status == self.status {
            menu.inputTextField.textView.becomeFirstResponder()
        } else {
            presentComposeController(inReplyTo: status)
        }
    }
    
    
    func presentComposeController(inReplyTo: Status) {
        let vc = ComposeController(inReplyTo: inReplyTo)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }


    func handleLike(postId: String) {
        NewsService.likePost(postId: postId)
    }


    func handleUserTap(userId: String) {
        let vc = UserController(userId: userId)
        self.navigationController?.pushViewController(vc, animated: true)
    }


    @objc func handleMore() {
        if status?.userId == Model.shared.uuid {
            presentCreatorAlert()
        } else {
            presentPublicAlert()
        }
    }

    func presentCreatorAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (delete) in
            self.confirmDelete()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in

        }
        alert.addAction(delete)
        alert.addAction(cancel)
        alert.presentOverKeyboard(animated: true, completion: {() in })
    }

    func presentPublicAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "Report", style: .destructive) { (report) in
            print("TO DO: REPORT POST")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in

        }
        alert.addAction(delete)
        alert.addAction(cancel)
        alert.presentOverKeyboard(animated: true, completion: {() in })
    }


    func confirmDelete() {
        guard let postId = status?.id else { return }
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .actionSheet)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { (delete) in
            NewsService.deletePost(postId: postId, completion: { (success) in
                if success == true {
                    self.navigationController?.popViewController(animated: true)
                    NotificationCenter.default.post(name: Notification.Name("reload"), object: nil, userInfo: nil)
                }
            })
        }
        let no = UIAlertAction(title: "No", style: .cancel) { (_) in

        }
        alert.addAction(yes)
        alert.addAction(no)
        definesPresentationContext = true
        modalPresentationStyle = .overCurrentContext
        alert.presentOverKeyboard(animated: true, completion: {() in })
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
    
    
    func handleReplyTap(inReplyToId: String) {
        let vc = StatusController(statusId: inReplyToId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
