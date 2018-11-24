//
//  LoginController.swift
//  Sparrow
//
//  Created by Hackr on 8/2/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import UIKit
import Firebase

class LoginController: UITableViewController, InputTextCellDelegate {
    
    let inputCell = "inputCell"
    var email = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(InputTextCell.self, forCellReuseIdentifier: inputCell)
        title = "Login"
        tableView.backgroundColor = Theme.darkBackground
        tableView.separatorColor = Theme.border
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(handleSubmit))
    }
    
    lazy var toolbar: LoginToolbar = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        let bar = LoginToolbar(frame: frame)
        bar.barTintColor = Theme.tintColor
        return bar
    }()
    
    override var inputAccessoryView: UIView? {
        return toolbar
    }
    
    
    @objc func handleSubmit() {
        UserService.login(email: email, password: password) { (success, message) in
            if success {
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil, userInfo: nil)
            } else {
                self.presentAlert(title: "Error", message: message ?? "")
            }
        }
    }
    
    
    func presentAlert(title: String, message: String?) {
        let alert = UIAlertController(title: "Sorry", message: message ?? "", preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .default, handler: nil)
        let password = UIAlertAction(title: "Reset Password", style: .destructive, handler: nil)
        alert.addAction(done)
        alert.addAction(password)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: inputCell, for: indexPath) as! InputTextCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.valueInput.textAlignment = .left
        cell.indexPath = indexPath
        switch indexPath.row {
        case 0:
            cell.valueInput.keyboardType = .emailAddress
            cell.valueInput.autocorrectionType = .no
            cell.valueInput.autocapitalizationType = .none
            let placeholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor:Theme.gray])
            cell.valueInput.attributedPlaceholder = placeholder
        case 1:
            cell.valueInput.keyboardType = .default
            cell.valueInput.isSecureTextEntry = true
            let placeholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor:Theme.gray])
            cell.valueInput.attributedPlaceholder = placeholder
        default:
            break
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func handleForgotPassword() {
        
    }
    
    
    func textFieldDidChange(indexPath: IndexPath, value: String) {
        if indexPath.row == 0 {
            email = value
        } else {
            password = value
        }
    }
    
    
}
