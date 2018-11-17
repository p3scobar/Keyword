//
//  ReplyView.swift
//  Chatter
//
//  Created by Hackr on 8/9/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit

class ReplyView: UIView {
    
    var name: String = ""
    var statusText: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
//        let height = statusText.height(forWidth: self.frame.width-24, font: Theme.medium(18))
//        statusHeightAnchor?.constant = (height <= 140) ? height : 140
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.bold(18)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = Theme.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.medium(18)
        label.numberOfLines = 5
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var statusHeightAnchor: NSLayoutConstraint?
    
    func setupView() {
        clipsToBounds = true
        addSubview(nameLabel)
        addSubview(statusLabel)
        
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
//        nameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        statusLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: 0).isActive = true
        statusLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
//        statusLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
