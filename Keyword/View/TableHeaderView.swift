//
//  TableHeaderView.swift
//  Chatter
//
//  Created by Hackr on 8/22/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit

class TableHeaderView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let background = UIView()
        background.backgroundColor = Theme.tintColor
        backgroundView = background
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.bold(22)
        label.textColor = Theme.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.border
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupView() {
        addSubview(titleLabel)
        addSubview(line)
        
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
        
        line.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        line.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
    
}
