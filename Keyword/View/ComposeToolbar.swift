//
//  ComposeToolbar.swift
//  Sparrow
//
//  Created by Hackr on 7/28/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


protocol ComposeDelegate: class {
    func handleSend()
    func handlePhotoIconTap()
}

import UIKit

class ComposeToolbar: UIToolbar {
    
    var inputDelegate: ComposeDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        barStyle = .blackOpaque
        isTranslucent = false
        barTintColor = Theme.tintColor
        tintColor = Theme.highlight
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        setItems([photoButton, flexibleSpace], animated: true)
        backgroundColor = .red
    }

    
    lazy var photoButton: UIBarButtonItem = {
        let photo = UIImage(named: "photo3")?.withRenderingMode(.alwaysTemplate)
        let button = UIBarButtonItem(image: photo, style: .done, target: self, action: #selector(handlePhoto))
        return button
    }()
    
    @objc func handlePhoto() {
        inputDelegate?.handlePhotoIconTap()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
