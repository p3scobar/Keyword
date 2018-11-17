//
//  StatusLinkViewSmall.swift
//  Chatter
//
//  Created by Hackr on 8/23/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import Foundation
import UIKit

protocol StatusLinkDelegate: class {
    func dismissLinkView()
}

class StatusLinkViewSmall: StatusLinkView {

    var delegate: StatusLinkDelegate?
    
    @objc func handleDismiss() {
        delegate?.dismissLinkView()
    }
    
    
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        let icon = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
        button.setImage(icon, for: .normal)
        button.tintColor = Theme.charcoal
        button.isHidden = true
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    override func setupView() {
        clipsToBounds = true
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(dismissButton)
        addSubview(mainImageView)
        addSubview(line)
   
        mainImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        mainImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        mainImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        line.leftAnchor.constraint(equalTo: mainImageView.leftAnchor).isActive = true
        line.topAnchor.constraint(equalTo: topAnchor).isActive = true
        line.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        line.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        subtitleLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: mainImageView.rightAnchor, constant: 12).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 0).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        dismissButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    }
    
}
