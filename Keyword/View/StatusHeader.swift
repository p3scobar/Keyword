//
//  StatusHeader.swift
//  Sparrow
//
//  Created by Hackr on 7/28/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit

protocol StatusHeaderDelegate {
    func handleUserTap(userId: String)
}

class StatusHeader: UIView {
    
    var delegate: StatusHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var status: Status? {
        didSet {
            statusLabel.text = status?.text
        }
    }
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Tom Ford"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "@tomford"
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 30
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var mainImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var buttonLike: UIButton = {
        let button = UIButton()
        let img = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
        button.setImage(img, for: .normal)
        button.tintColor = Theme.gray
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var likeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "12"
        label.textColor = Theme.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var buttonComment: UIButton = {
        let button = UIButton()
        let img = UIImage(named: "comment")?.withRenderingMode(.alwaysTemplate)
        button.setImage(img, for: .normal)
        button.tintColor = Theme.gray
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "28"
        label.textColor = Theme.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc func handleComment() {
        
    }
    
    @objc func handleLike() {
        
    }
    
    @objc func handleUserTap() {
        guard let userId = status?.userId else { return }
        delegate?.handleUserTap(userId: userId)
    }
    
    func setupView() {
        backgroundColor = .white
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(mainImageView)
        addSubview(statusLabel)
//        addSubview(commentLabel)
//        addSubview(likeLabel)
        addSubview(buttonLike)
        addSubview(buttonComment)
        addSubview(topLine)
        addSubview(bottomLine)
        
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 0).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true

        statusLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 14).isActive = true
        statusLabel.leftAnchor.constraint(equalTo: profileImageView.leftAnchor, constant: 0).isActive = true
        statusLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 0).isActive = true
        
        topLine.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 50).isActive = true
        topLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        topLine.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        topLine.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        bottomLine.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: 50).isActive = true
        bottomLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomLine.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        buttonComment.leftAnchor.constraint(equalTo: profileImageView.leftAnchor).isActive = true
        buttonComment.widthAnchor.constraint(equalToConstant: 24).isActive = true
        buttonComment.heightAnchor.constraint(equalToConstant: 24).isActive = true
        buttonComment.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: 12).isActive = true
        
//        commentLabel.leftAnchor.constraint(equalTo: buttonLike.rightAnchor, constant: 8).isActive = true
//        commentLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        commentLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        commentLabel.centerYAnchor.constraint(equalTo: buttonLike.centerYAnchor).isActive = true
        
        buttonLike.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: 0).isActive = true
        buttonLike.widthAnchor.constraint(equalToConstant: 24).isActive = true
        buttonLike.heightAnchor.constraint(equalToConstant: 24).isActive = true
        buttonLike.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: 12).isActive = true
        
//        likeLabel.leftAnchor.constraint(equalTo: buttonComment.rightAnchor, constant: 8).isActive = true
//        likeLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        likeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        likeLabel.centerYAnchor.constraint(equalTo: buttonLike.centerYAnchor).isActive = true
        
        
        let userTap = UITapGestureRecognizer(target: self, action: #selector(handleUserTap))
        profileImageView.addGestureRecognizer(userTap)
        
    }
    
    
}
