//
//  CommentCell.swift
//  Sparrow
//
//  Created by Hackr on 8/2/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import Foundation
import UIKit

protocol CommentCellDelegate {
    func handleUserTap(userId: String)
}

class ActivityCell: UITableViewCell {
    
    var delegate: CommentCellDelegate?
    
    var activity: Activity? {
        didSet {
            formatText()
            if let image = activity?.userImage {
                let url = URL(string: image)
                profileImage.kf.setImage(with: url)
            }
            
            backgroundColor = activity!.unread ? Theme.tintColor : Theme.cellBackground
        }
    }
    
    func formatText() {
        let formattedString = NSMutableAttributedString()
        guard let type = activity?.type else { return }
        let name = activity?.name ?? ""
        
        if type == "follow" {
            formattedString.bold(name)
            nameLabel.attributedText = formattedString
            statusLabel.text = "Started following you"
        } else if type == "like" {
            let text = " liked your status"
            formattedString.bold(name).normal(text)
            nameLabel.attributedText = formattedString
            statusLabel.text = activity?.text ?? ""
        } else if type == "mention" {
            let text = " mentioned you"
            formattedString.bold(name).normal(text)
            nameLabel.attributedText = formattedString
            statusLabel.text = activity?.text ?? ""
        } else if type == "reply" {
            let text = " replied"
            formattedString.bold(name).normal(text)
            nameLabel.attributedText = formattedString
            statusLabel.text = activity?.text
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        backgroundColor = Theme.cellBackground
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleUserTap))
        profileImage.addGestureRecognizer(tap)
    }
    
    @objc func handleUserTap() {
        guard let uid = activity?.userId else { return }
        delegate?.handleUserTap(userId: uid)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profileImage: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 16, y: 10, width: 56, height: 56))
        view.layer.cornerRadius = 28
        view.backgroundColor = Theme.unfilled
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        view.layer.masksToBounds = true
        return view
    }()
    
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.medium(18)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textColor = Theme.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var chatBubble: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.lightBackground
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    lazy var unreadView: UIView = {
//        let view = UIView()
//        view.backgroundColor = Theme.highlight
//        view.isHidden = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    
    func setupView() {
        selectionStyle = .none
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(statusLabel)
//        addSubview(unreadView)
        
        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 12).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: -1).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
//        activityLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
//        activityLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
//        activityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
//        activityLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true

        statusLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        statusLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        statusLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true

//        unreadView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        unreadView.widthAnchor.constraint(equalToConstant: 5).isActive = true
//        unreadView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        unreadView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//
        
    }
    
}
