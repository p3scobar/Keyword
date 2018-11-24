//
//  UsernameCell.swift
//  Keyword
//
//  Created by Hackr on 11/23/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit
import Kingfisher

class UsernameCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            if let name = user?.name {
                self.nameLabel.text = name
            }
            
            if let username = user?.username {
                usernameLabel.text = "@\(username)"
            }
            profileImage.image = nil
            if let image = user?.image {
                let url = URL(string: image)
                self.profileImage.kf.setImage(with: url)
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
    
    
    let profileImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 44, height: 44))
        imageView.layer.cornerRadius = 22
        imageView.backgroundColor = Theme.unfilled
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 60, y: 10, width: self.frame.width-60, height: 24))
        label.font = Theme.semibold(16)
        label.numberOfLines = 1
        label.textColor = .white
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 60, y: 32, width: self.frame.width-60, height: 24))
        label.font = Theme.medium(16)
        label.textColor = Theme.gray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupView() {
        backgroundColor = Theme.cellBackground
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        
//        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
//        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
//        profileImage.heightAnchor.constraint(equalToConstant: 48).isActive = true
//        profileImage.widthAnchor.constraint(equalToConstant: 48).isActive = true
//        
//        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 12).isActive = true
//        nameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: -1).isActive = true
//        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
//        nameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
//        
//        usernameLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
//        usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
//        usernameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
//        usernameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
    }
    
}
