//
//  StatusLinkView.swift
//  Chatter
//
//  Created by Hackr on 8/20/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit

class StatusLinkView: UIView {
    
    var linkUrl: String? {
        didSet {
            if let host = URL(string: linkUrl!)?.host {
                subtitleLabel.text = host
            }
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title!
            
        }
    }
    
    var imageUrl: String? {
        didSet {
            let url = URL(string: imageUrl!)
            mainImageView.kf.setImage(with: url)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.bold(18)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textColor = Theme.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.medium(16)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = Theme.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mainImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = Theme.tintColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    lazy var container: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = Theme.tintColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.border
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    func setupView() {
        addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)
        container.addSubview(mainImageView)
        addSubview(line)
        
        container.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        container.topAnchor.constraint(equalTo: topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        mainImageView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 20).isActive = true
        
        line.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        line.topAnchor.constraint(equalTo: mainImageView.bottomAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        line.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        subtitleLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
}
