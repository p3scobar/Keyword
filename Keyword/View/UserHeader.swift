//
//  UserHeader.swift
//  Sparrow
//
//  Created by Hackr on 7/28/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import Foundation
import UIKit

protocol UserHeaderDelegate: class {
    func handleFollow()
    func handlePay()
}

class UserHeader: UIView {
    
    var delegate: UserHeaderDelegate?
    
    var following: Bool = false {
        didSet {
            if following == true {
                print("following")
                followButton.isSelected = true
                followButton.backgroundColor = Theme.highlight
            } else {
                print("not following")
                followButton.isSelected = false
                followButton.backgroundColor = .clear
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var user: User? {
        didSet {
            nameLabel.text = user?.name ?? ""
            if let username = user?.username {
                usernameLabel.text = "@\(username)"
            }
            if let userImage = user?.image {
                let url = URL(string: userImage)
                profileImageView.kf.setImage(with: url)
            }
            if let bio = user?.bio {
                bioLabel.text = bio
            }
            checkIfUserHasPublicKey()
            if isCurrentUser {
                followButton.isHidden = true
                payButton.isHidden = true
            } else {
                followButton.isHidden = false
                payButton.isHidden = false
            }
        }
    }
    
    func checkIfUserHasPublicKey() {
        if user?.publicKey != nil, user?.publicKey != "" {
            payButton.isEnabled = true
            payButton.isHidden = false
            payButton.layer.borderColor = Theme.highlight.cgColor
        } else {
            payButton.isEnabled = false
            payButton.isHidden = true
            payButton.layer.borderColor = Theme.highlight.withAlphaComponent(0.3).cgColor
        }
    }
    
    var isCurrentUser: Bool {
        guard let uid = user?.id else { return false }
        return uid == Model.shared.uuid
    }
    
    lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 54
        view.backgroundColor = Theme.unfilled
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.bold(28)
        label.numberOfLines = 0
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.semibold(18)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = Theme.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let followButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Theme.highlight, for: .normal)
        button.setTitleColor(Theme.white, for: .selected)
        button.setTitle("Follow", for: .normal)
        button.setTitle("Following", for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.borderWidth = 2
        button.layer.borderColor = Theme.highlight.cgColor
        button.layer.cornerRadius = 18
        button.isHidden = true
        button.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var payButton: UIButton = {
        let button = UIButton()
        button.setTitle("Pay", for: .normal)
        button.setTitleColor(Theme.highlight, for: .normal)
        button.setTitleColor(Theme.highlight.withAlphaComponent(0.3), for: .disabled)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 2
        button.layer.borderColor = Theme.highlight.cgColor
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePay), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.medium(18)
        label.numberOfLines = 0
        label.textColor = Theme.white
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    @objc func handleFollow() {
        delegate?.handleFollow()
        following = !following
    }
    
    @objc func handlePay() {
        delegate?.handlePay()
    }

    func setupView() {
        backgroundColor = Theme.tintColor
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(followButton)
        addSubview(payButton)
        addSubview(bioLabel)
        
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 108).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 108).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 0).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -5).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        
        bioLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16).isActive = true
        bioLabel.leftAnchor.constraint(equalTo: profileImageView.leftAnchor, constant: 0).isActive = true
        bioLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 0).isActive = true
        bioLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        followButton.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        followButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 0).isActive = true
        followButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
      
        payButton.leftAnchor.constraint(equalTo: followButton.rightAnchor, constant: 12).isActive = true
        payButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        payButton.bottomAnchor.constraint(equalTo: followButton.bottomAnchor).isActive = true
        payButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        

    }
    
    
}

