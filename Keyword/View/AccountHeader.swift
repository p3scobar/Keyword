//
//  AccountHeader.swift
//  Sparrow
//
//  Created by Hackr on 7/28/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import UIKit
//import Kingfisher

protocol AccountDelegate: class {
    func handleEditButtonTap()
    func handleEditProfilePic()
}

class AccountHeader: UIView {
    
    var delegate: AccountController?
    var tap: UIGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Theme.cellBackground
        setupView()
        tap = UITapGestureRecognizer(target: self, action: #selector(editProfilePic))
        profileImage.addGestureRecognizer(tap)
        setupNameAndProfileImage()
    }
    
    func setupNameAndProfileImage() {
        nameLabel.text = Model.shared.name
        usernameLabel.text = "@\(Model.shared.username)"
        let url = URL(string: Model.shared.profileImage)
        profileImage.kf.setImage(with: url)
    }
    
    @objc func editProfilePic() {
        delegate?.handleEditProfilePic()
    }
    
    @objc func handleEdit() {
        delegate?.handleEditButtonTap()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let profileImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.borderWidth = 0
        view.layer.cornerRadius = 54
        view.layer.masksToBounds = true
        view.backgroundColor = Theme.unfilled
//        view.layer.borderWidth = 0.5
//        view.layer.borderColor = Theme.border.cgColor
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.bold(24)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.semibold(18)
        label.textColor = .gray
        label.textColor = Theme.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    let bioLabel: UITextView = {
//        let view = UITextView()
//        view.font = Theme.medium(18)
//        view.textContainerInset = UIEdgeInsetsMake(10, 15, 0, 15)
//        view.textColor = .lightGray
//        view.isEditable = false
//        view.text = "I am the creator of this social thing."
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(Theme.highlight, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderColor = Theme.highlight.cgColor
        button.layer.borderWidth = 2
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var contentSeparatorView: UIView = {
        let view = UIView()
//        view.layer.borderColor = Theme.borderColor.cgColor
        view.layer.borderWidth = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var bottomSeparatorView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    func setupView() {
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(editButton)
        addSubview(bottomSeparatorView)
        
        editButton.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        editButton.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 108).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 108).isActive = true
        profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: 0).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor, constant: -8).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        bottomSeparatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bottomSeparatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        bottomSeparatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    
    
    
}

