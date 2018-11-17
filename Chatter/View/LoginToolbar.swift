//
//  LoginToolbar.swift
//  Sparrow
//
//  Created by Hackr on 8/2/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class LoginToolbar: UIToolbar {
    
    var loginVc: LoginController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setItems([passwordButton], animated: false)
    }
    
    let passwordButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Forgot Password?", style: .done, target: self, action: #selector(handleForgotPWTap))
        button.tintColor = .black
        return button
    }()
    
    @objc func handleForgotPWTap() {
        loginVc?.handleForgotPassword()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
