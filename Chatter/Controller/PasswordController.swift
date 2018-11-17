//
//  PasswordController.swift
//  Sparrow
//
//  Created by Hackr on 8/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import UIKit
import Firebase

class PasswordController: UITableViewController, InputTextCellDelegate {
    
    private var currentEmail = Model.shared.email
    private var currentPassword: String?
    private var newPassword: String?
    private var confirmNewPassword: String?
    
    let inputCell = "inputCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(InputTextCell.self, forCellReuseIdentifier: inputCell)
        title = "Change Password"
        tableView.tableFooterView = UIView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(handleSubmit))
    }
    
    
    @objc func handleSubmit() {
        let email = currentEmail
        guard let password = currentPassword,
            let newPassword = newPassword,
            let confirmPassword = confirmNewPassword else {
                presentAlertController(title: "Oops", message: "Please include all fields.", popVC: false)
                return
        }
        guard newPassword == confirmPassword else {
            presentAlertController(title: "Error", message: "Passwords do not match.", popVC: false)
            return
        }
        guard password != newPassword else {
            presentAlertController(title: "Error", message: "Cannot update to the same password.", popVC: false)
            return
        }
        
//        UserManager.updatePassword(email: email, password: password, newPassword: newPassword) { (success, message) in
//            if success {
//                self.presentAlertController(title: "Success", message: "Password updated.", popVC: true)
//            } else {
//                guard let errorMessage = message else { return }
//                self.presentAlertController(title: "Oops", message: errorMessage, popVC: false)
//            }
//        }
    }
    
    
    func presentAlertController(title: String, message: String, popVC: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .default) { (tap) in
            if popVC {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(done)
        present(alert, animated: true, completion: nil)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: inputCell, for: indexPath) as! InputTextCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.valueInput.keyboardAppearance = .dark
        cell.valueInput.textAlignment = .left
        cell.indexPath = indexPath
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell.valueInput.keyboardType = .default
            cell.valueInput.autocorrectionType = .no
            cell.valueInput.autocapitalizationType = .none
            cell.valueInput.isSecureTextEntry = true
            let placeholder = NSAttributedString(string: "Current Password", attributes: [NSAttributedStringKey.foregroundColor:Theme.gray])
            cell.valueInput.attributedPlaceholder = placeholder
        case (1,0):
            cell.valueInput.keyboardType = .default
            cell.valueInput.autocorrectionType = .no
            cell.valueInput.autocapitalizationType = .none
            cell.valueInput.isSecureTextEntry = true
            let placeholder = NSAttributedString(string: "New Password", attributes: [NSAttributedStringKey.foregroundColor:Theme.gray])
            cell.valueInput.attributedPlaceholder = placeholder
        case (1,1):
            cell.valueInput.keyboardType = .default
            cell.valueInput.autocorrectionType = .no
            cell.valueInput.autocapitalizationType = .none
            cell.valueInput.isSecureTextEntry = true
            let placeholder = NSAttributedString(string: "Confirm New Password", attributes: [NSAttributedStringKey.foregroundColor:Theme.gray])
            cell.valueInput.attributedPlaceholder = placeholder
        default:
            break
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    func textFieldDidChange(indexPath: IndexPath, value: String) {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            currentPassword = value
        case (1,0):
            newPassword = value
        case (1,1):
            confirmNewPassword = value
        default:
            break
        }
    }
    
    
}

