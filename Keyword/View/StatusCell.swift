//
//  NewsCell.swift
//  Sparrow
//
//  Created by Hackr on 7/27/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import ActiveLabel

protocol StatusCellDelegate: class {
    func handleComment(status: Status)
    func handleLike(postId: String)
    func handleUserTap(userId: String)
    func handleLinkTap(url: URL)
    func handleMentionTap(_ username: String)
    func handleHashtagTap(_ hashtag: String)
    func handleImageTap(imageView: UIImageView)
    func handleReplyTap(inReplyToId: String)
}

class StatusCell: UITableViewCell {
    
    var indexPath: IndexPath!
    var delegate: StatusCellDelegate?
    var replyTap: UITapGestureRecognizer?
    var linkTap: UITapGestureRecognizer?
    
    var likeCount: Int = 0 {
        didSet {
            if likeCount > 0 {
                likeButton.titleLabel.text = "\(likeCount)"
            } else {
                likeButton.titleLabel.text = ""
            }
        }
    }
    
    var like: Bool = false {
        didSet {
            if like == true {
                likeButton.isHighlighted = true
                likeButton.icon.tintColor = Theme.red
                likeButton.icon.image = UIImage(named: "heartFilled")?.withRenderingMode(.alwaysTemplate)
            } else {
                likeButton.isHighlighted = false
                likeButton.icon.tintColor = Theme.gray
                likeButton.icon.image = UIImage(named: "heart2")?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    
    var status: Status? {
        didSet {
            setupCell()
            guard let postID = status?.id else { return }
            like = Like.checkIfLiked(postId: postID)
        }
    }
    
    func setupName() {
        let formattedString = NSMutableAttributedString()
        if let name = status?.name, let username = status?.username {
            formattedString.bold(name).normal(" @\(username)")
            nameLabel.attributedText = formattedString
        }
    }
    
    func setupCell() {
        setupName()
        setupImage()
        
        statusLabel.text = status?.text
        if let text = status?.text, text != "" {
            let width = UIScreen.main.bounds.width-100
            let textHeight = text.height(forWidth: width, font: Theme.medium(18))
            statusHeightAnchor?.constant = textHeight
        } else {
            statusHeightAnchor?.constant = 0
        }
        
        if let commentCount = status?.commentCount, commentCount > 0 {
            commentButton.titleLabel.text = "\(commentCount)"
        }
        
        if let likes = status?.likeCount {
            likeCount = Int(likes)
        } else {
            likeCount = 0
        }
        
        setupLinkView()
        
        if let inReplyToId = status?.inReplyToId, inReplyToId.count > 0 {
            guard let replyText = status?.inReplyToText else {
                replyView.isHidden = true
                return
            }
            replyView.statusText = replyText
            replyView.isHidden = false
            configureReplyHeight()

            if let name = status?.inReplyToName {
                replyView.nameLabel.text = name
            }
            if let text = status?.inReplyToText {
                replyView.statusLabel.text = text
            }
            replyTap = UITapGestureRecognizer(target: self, action: #selector(handleReplyTap))
            replyView.addGestureRecognizer(replyTap!)
        } else {
            replyView.isHidden = true
            replyHeightAnchor?.constant = 0
        }
        
        if let linkTitle = status?.linkTitle {
            linkView.titleLabel.text = linkTitle
        }
        
        if let linkImage = status?.linkImage, linkImage != "" {
            let url = URL(string: linkImage)
            linkView.mainImageView.kf.setImage(with: url)
        }
        
        if let userImageUrl = status?.userImage {
            let url = URL(string: userImageUrl)
            profileImageView.kf.setImage(with: url)
        }
    }
    
    func setupImage() {
        if let imageUrl = status?.image, imageUrl != "" {
            imageHeightAnchor?.constant = 180
            let url = URL(string: imageUrl)
            mainImageView.kf.setImage(with: url)
        } else {
            mainImageView.image = nil
            imageHeightAnchor?.constant = 0
        }
    }
    
    func setupLinkView() {
        if let linkUrl = status?.link {
            linkTap = UITapGestureRecognizer(target: self, action: #selector(handleLinkTap))
            linkView.addGestureRecognizer(linkTap!)
            linkHeightAnchor?.constant = 230
            linkView.isHidden = false
            linkView.linkUrl = linkUrl
        } else {
            linkView.isHidden = true
            linkHeightAnchor?.constant = 0
        }
    }
    
    func configureReplyHeight() {
        guard let replyText = status?.inReplyToText else { return }
        let replyTextHeight = replyText.height(forWidth: UIScreen.main.bounds.width-124, font: Theme.medium(18))+48
        replyHeightAnchor?.constant = (replyTextHeight <= 160) ? replyTextHeight : 160
    }
    
    @objc func handleReplyTap() {
        guard let replyId = status?.inReplyToId else { return }
            delegate?.handleReplyTap(inReplyToId: replyId)
    }
    
    @objc func handleLinkTap() {
        guard let urlString = linkView.linkUrl, let url = URL(string: urlString) else { return }
        delegate?.handleLinkTap(url: url)
    }
    
    lazy var statusLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = Theme.medium(18)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.mentionColor = Theme.blue
        label.hashtagColor = Theme.blue
        label.URLColor = Theme.blue
        label.textColor = Theme.white
        label.handleHashtagTap({ (hashtag) in
            self.handleHashtagTap(hashtag)
        })
        label.handleMentionTap({ (username) in
            self.handleMentionTap(username)
        })
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.white
        label.font = Theme.bold(18)
        label.lineBreakMode = .byClipping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    lazy var profileImageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 16, y: 10, width: 56, height: 56))
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 28
        view.backgroundColor = Theme.unfilled
        view.clipsToBounds = true
//        view.layer.borderColor = Theme.border.cgColor
//        view.layer.borderWidth = 0.5
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var mainImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.borderColor = Theme.border.cgColor
        view.layer.borderWidth = 0.5
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        view.addGestureRecognizer(tap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var linkView: StatusLinkView = {
        let view = StatusLinkView()
        view.layer.borderColor = Theme.border.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 12
        view.isHidden = true
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var replyView: ReplyView = {
        let view = ReplyView()
        view.layer.borderColor = Theme.border.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 12
        view.isHidden = true
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var likeButton: StatusButton = {
        let button = StatusButton(imageName: "heart2", title: "")
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var commentButton: StatusButton = {
        let button = StatusButton(imageName: "reply", title: "")
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.border
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    @objc func handleImageTap() {
        delegate?.handleImageTap(imageView: mainImageView)
    }
    
    func handleHashtagTap(_ hashtag: String) {
        delegate?.handleHashtagTap(hashtag)
    }
    
    func handleMentionTap(_ username: String) {
        let lowercased = username.lowercased()
        delegate?.handleMentionTap(lowercased)
    }
    
    
    @objc func handleComment() {
        guard let status = status else { return }
        delegate?.handleComment(status: status)
    }
    
    @objc func handleLike() {
        guard let id = status?.id else { return }
        like = !like
        if like {
            likeCount += 1
            status?.likeCount += Int16(exactly: 1)!
        } else {
            likeCount -= 1
            status?.likeCount -= Int16(exactly: 1)!
        }
        delegate?.handleLike(postId: id)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        let userTap = UITapGestureRecognizer(target: self, action: #selector(handleUserTap))
        profileImageView.addGestureRecognizer(userTap)
        backgroundColor = Theme.cellBackground
    }
    
    
    @objc func handleUserTap() {
        guard let id = status?.userId else { return }
        delegate?.handleUserTap(userId: id)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageHeightAnchor: NSLayoutConstraint?
    var linkHeightAnchor: NSLayoutConstraint?
    var linkWidthAnchor: NSLayoutConstraint?
    var replyHeightAnchor: NSLayoutConstraint?
    var statusHeightAnchor: NSLayoutConstraint?
    
    func setupView() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(statusLabel)
        addSubview(mainImageView)
        addSubview(linkView)
        addSubview(replyView)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(bottomLine)
        
        mainImageView.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        mainImageView.topAnchor.constraint(equalTo: linkView.bottomAnchor, constant: 0).isActive = true
        imageHeightAnchor = mainImageView.heightAnchor.constraint(equalToConstant: 0)
        imageHeightAnchor?.isActive = true
        
        replyView.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        replyView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        replyView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 0).isActive = true
        replyHeightAnchor = replyView.heightAnchor.constraint(equalToConstant: 0)
        replyHeightAnchor?.isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: -1).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        statusLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        statusLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        statusHeightAnchor = statusLabel.heightAnchor.constraint(equalToConstant: 0)
        statusHeightAnchor?.isActive = true
        
        linkView.leftAnchor.constraint(equalTo: statusLabel.leftAnchor).isActive = true
        linkView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        linkView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 12).isActive = true
        linkHeightAnchor = linkView.heightAnchor.constraint(equalToConstant: 0)
        linkHeightAnchor?.isActive = true
        
        likeButton.leftAnchor.constraint(equalTo: centerXAnchor, constant: -24).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        likeButton.topAnchor.constraint(equalTo: commentButton.topAnchor).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        commentButton.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        commentButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        commentButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        commentButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        bottomLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomLine.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
}
