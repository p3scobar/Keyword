//
//  UsernameController.swift
//  Sparrow
//
//  Created by Hackr on 8/2/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class UsernameController: UIViewController, UITextFieldDelegate {
    
    var username = ""
    var available = false
    var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputField.text = Model.shared.username
        view.backgroundColor = Theme.darkBackground
        setupView()
        self.title = "Username"
        saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
        self.navigationItem.rightBarButtonItem = saveButton
        inputField.delegate = self
        inputField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    var isModal: Bool {
        return presentingViewController != nil ||
            navigationController?.presentingViewController?.presentedViewController === navigationController ||
            tabBarController?.presentingViewController is UITabBarController
    }
    
    @objc func handleSave() {
        guard let text = inputField.text else { return }
        UserService.updateUsername(username: text) { (result) in
            if result == true {
                if self.isModal {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.presentFailureAlert()
            }
        }
    }
    
    func presentFailureAlert() {
        let alert = UIAlertController(title: "Unavailable", message: "Please select another username", preferredStyle: .actionSheet)
        let done = UIAlertAction(title: "Done", style: .default) { (_) in }
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Select a Username"
        label.textAlignment = .center
        label.textColor = Theme.gray
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let inputField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 8
        view.backgroundColor = Theme.tintColor
        view.textColor = Theme.white
        view.font = Theme.medium(18)
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.keyboardType = .twitter
        view.textAlignment = .center
        view.keyboardAppearance = .dark
        view.textRect(forBounds: CGRect(x: 20, y: 0, width: 20, height: 10))
        view.placeholder = "@username"
        if view.placeholder != nil {
            view.attributedPlaceholder = NSAttributedString(string: view.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: Theme.gray])
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    lazy var toolbar: UIToolbar = {
//        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
//        let bar = UIToolbar(frame: frame)
//        return bar
//    }()
    
//    let resultsLabel: UILabel = {
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
//        label.textColor = Theme.gray
//        label.font = Theme.medium(16)
//        label.textAlignment = .center
//        return label
//    }()
    
//    override var inputAccessoryView: UIView? {
//        return toolbar
//    }
    
    
    func setupView() {
        view.addSubview(label)
        view.addSubview(inputField)
        
//        toolbar.addSubview(resultsLabel)
        
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        inputField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        inputField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        inputField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        inputField.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    
    @objc func textFieldDidChange() {
        available = false
        guard let text = inputField.text else { return }
        username = text

//        UserManager.usernameAvailable(username: text) { (available) in
//            if !available || text.count < 4 {
//                self.resultsLabel.text = "Unavailable"
//                self.saveButton.isEnabled = false
//                self.available = false
//                if self.username == Model.shared.username {
//                    self.resultsLabel.text = "Hello @\(self.username)!"
//                }
//            } else {
//                self.resultsLabel.text = "👍"
//                self.available = true
//                self.saveButton.isEnabled = true
//            }
//        }
    }
    
    
}

