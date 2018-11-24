//
//  PaymentCell.swift
//  Chatter
//
//  Created by Hackr on 9/4/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import UIKit
import Firebase
import Kingfisher

class PaymentCell: UITableViewCell {
    
    weak var payment: Payment? {
        didSet {
            self.nameLabel.text = payment!.fetchOtherName()
            let imageUrl = payment!.fetchOtherImage()
            let url = URL(string: imageUrl)
            self.profileImage.kf.setImage(with: url)
            let amount = Decimal(string: payment!.amount ?? "0.00")?.rounded(2)
            amountLabel.text = amount
        }
    }
    
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 28
        imageView.backgroundColor = Theme.unfilled
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.semibold(18)
        label.textColor = Theme.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.semibold(18)
        label.textAlignment = .right
        label.textColor = Theme.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = Theme.cellBackground
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(amountLabel)
        
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 56).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 56).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 16).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        amountLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        amountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -26).isActive = true
        amountLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

