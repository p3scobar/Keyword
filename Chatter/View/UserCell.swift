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

class UserCell: UITableViewCell {
    
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
    
    var bioHeightAnchor: NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = Theme.cellBackground
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(bioLabel)
        
        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 12).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: -1).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        usernameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
        
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
