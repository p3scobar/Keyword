//
//  EmailController.swift
//  Sparrow
//
//  Created by Hackr on 8/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import UIKit
import Firebase

class EmailController: UITableViewController, InputTextCellDelegate {
    
    var currentEmail = Model.shared.email
    var newEmail: String?
    var password: String?
    
    let inputCell = "inputCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(InputTextCell.self, forCellReuseIdentifier: inputCell)
        title = "Change Email"
        tableView.tableFooterView = UIView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(handleSubmit))
    }
    
    
    @objc func handleSubmit() {
        let email = Model.shared.email
        guard let new = newEmail,
            let password = password
            else {
                presentAlertController(title: "Oops", message: "Please include an email & password.", popVC: false)
                return
        }
//        UserManager.updateEmail(email: email, newEmail: new, password: password) { (success, message) in
//            if success {
//                self.presentAlertController(title: "Success", message: "Email updated.", popVC: true)
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
        cell.valueInput.keyboardAppearance = .dark
        cell.valueInput.textAlignment = .left
        cell.indexPath = indexPath
        switch indexPath.row{
        case 0:
            cell.valueInput.keyboardType = .twitter
            cell.valueInput.autocorrectionType = .no
            cell.valueInput.autocapitalizationType = .none
            let placeholder = NSAttributedString(string: "New Email", attributes: [NSAttributedStringKey.foregroundColor:Theme.gray])
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
    
    
    func textFieldDidChange(indexPath: IndexPath, value: String) {
        if indexPath.row == 0 {
            newEmail = value
        } else if indexPath.row == 1 {
            password = value
        }
        
    }
    
    
}

