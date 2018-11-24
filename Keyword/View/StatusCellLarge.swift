//
//  StatusCellSmall.swift
//  Chatter
//
//  Created by Hackr on 8/16/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit

class StatusCellLarge: StatusCell {
    
    override var status: Status? {
        didSet {
            if let username = status?.username {
                usernameLabel.text = "@\(username)"
            }
            
            if let timestamp = status?.timestamp {
                self.dateLabel.text = timestamp.formatted()
            }
            if let text = status?.text, text != "" {
                let textHeight = text.height(forWidth: self.frame.width-32, font: Theme.regular(22))
                statusHeightAnchor?.constant = textHeight
            }
        }
    }
    
    override func setupImage() {
        if let imageUrl = status?.image, imageUrl != "" {
            imageHeightAnchor?.constant = 240
            let url = URL(string: imageUrl)
            mainImageView.kf.setImage(with: url)
        } else {
            mainImageView.image = nil
            imageHeightAnchor?.constant = 0
        }
    }
    
    override func setupName() {
        if let name = status?.name {
            nameLabel.text = name
        }
    }
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.medium(18)
        label.textColor = Theme.gray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.regular(18)
        label.lineBreakMode = .byClipping
        label.numberOfLines = 1
        label.textColor = Theme.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func configureReplyHeight() {
        guard let replyText = status?.inReplyToText else { return }
        let replyTextHeight = replyText.height(forWidth: UIScreen.main.bounds.width-64, font: Theme.medium(18))+48
        replyHeightAnchor?.constant = (replyTextHeight <= 160) ? replyTextHeight : 160
    }
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.border
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupView() {
        nameLabel.font = Theme.bold(24)
        statusLabel.font = Theme.regular(22)
        
        likeButton.iconHeight?.constant = 20
        likeButton.iconWidth?.constant = 20
        
        commentButton.iconHeight?.constant = 20
        commentButton.iconWidth?.constant = 20
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(statusLabel)
        addSubview(mainImageView)
        addSubview(linkView)
        addSubview(replyView)
        addSubview(dateLabel)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(bottomLine)
        addSubview(line)

        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 0).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        statusLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        statusLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        statusLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20).isActive = true
        statusHeightAnchor = statusLabel.heightAnchor.constraint(equalToConstant: 0)
        statusHeightAnchor?.isActive = true
        
        linkView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        linkView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        linkView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 12).isActive = true
        linkHeightAnchor = super.linkHeightAnchor
        
        mainImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        mainImageView.topAnchor.constraint(equalTo: linkView.bottomAnchor, constant: 0).isActive = true
        imageHeightAnchor = mainImageView.heightAnchor.constraint(equalToConstant: 0)
        imageHeightAnchor?.isActive = true
        
        replyView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        replyView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        replyView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 0).isActive = true
        replyHeightAnchor = replyView.heightAnchor.constraint(equalToConstant: 0)
        replyHeightAnchor?.isActive = true
        
        linkView.leftAnchor.constraint(equalTo: statusLabel.leftAnchor).isActive = true
        linkView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        linkView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 12).isActive = true
        linkHeightAnchor = linkView.heightAnchor.constraint(equalToConstant: 0)
        linkHeightAnchor?.isActive = true
        
        line.bottomAnchor.constraint(equalTo: commentButton.topAnchor, constant: -8).isActive = true
        line.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -16).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        likeButton.leftAnchor.constraint(equalTo: centerXAnchor, constant: -24).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        likeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        commentButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        commentButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        commentButton.topAnchor.constraint(equalTo: likeButton.topAnchor).isActive = true
        commentButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }
    
}
