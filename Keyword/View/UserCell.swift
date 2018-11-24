//
//  UserCell.swift
//  Sparrow
//
//  Created by Hackr on 8/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import UIKit
import Firebase
import Kingfisher

protocol UserCellDelegate {
    func handleFollowButtonTap(userId: String)
}

class UserCell: UITableViewCell {
    
    var delegate: UserCellDelegate?
    
    weak var user: User? {
        didSet {
            if let name = user?.name {
                self.nameLabel.text = name
            }
            
            if let username = user?.username {
                usernameLabel.text = "@\(username)"
            }
            if let bio = user?.bio {
                bioHeightAnchor?.constant = bio.height(forWidth: frame.width-84, font: Theme.medium(18))
                bioLabel.text = bio
            } else {
                bioHeightAnchor?.constant = 0
                bioLabel.text = nil
            }
            profileImage.image = nil
            if let image = user?.image {
                let url = URL(string: image)
                self.profileImage.kf.setImage(with: url)
            }
        }
    }
    
    
    let profileImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 16, y: 10, width: 56, height: 56))
        imageView.layer.cornerRadius = 28
        imageView.backgroundColor = Theme.unfilled
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.bold(18)
        label.numberOfLines = 1
        label.textColor = Theme.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.medium(18)
        label.textColor = Theme.gray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.medium(18)
        label.textColor = Theme.lightGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var following: Bool = false {
        didSet {
            if following {
                followButton.isSelected = true
                followButton.backgroundColor = Theme.highlight
            } else {
                followButton.isSelected = false
                followButton.backgroundColor = Theme.cellBackground
            }
        }
    }
    
    lazy var followButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Theme.medium(16)
        button.setTitleColor(Theme.highlight, for: .normal)
        button.setTitleColor(Theme.white, for: .selected)
        button.backgroundColor = Theme.cellBackground
        button.setTitle("Follow", for: .normal)
        button.setTitle("Following", for: .selected)
        button.layer.borderColor = Theme.highlight.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 18
        button.isHidden = true
        button.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleFollow() {
        following = !following
        guard let id = user?.id else { return }
        delegate?.handleFollowButtonTap(userId: id)
    }
    
    var bioHeightAnchor: NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = Theme.cellBackground
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(bioLabel)
        addSubview(followButton)
        
        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 12).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: -1).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        usernameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
        
        followButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        followButton.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 4).isActive = true
        followButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: 88).isActive = true
        
        bioLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2).isActive = true
        bioLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        bioHeightAnchor = bioLabel.heightAnchor.constraint(equalToConstant: 0)
        bioHeightAnchor?.isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension User {
    
    func height() -> CGFloat {
        var height: CGFloat = 72
        if let bio = self.bio {
            let width = UIScreen.main.bounds.width-84
            let textHeight = bio.height(forWidth: width, font: Theme.medium(18))+10
            height += textHeight
        }
        return height
    }
    
}
