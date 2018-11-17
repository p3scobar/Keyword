//
//  SignupController.swift
//  Sparrow
//
//  Created by Hackr on 8/2/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit
import Firebase

class SignupController: UITableViewController, InputTextCellDelegate {
    
    let inputCell = "inputCell"
    var name = ""
    var email = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(InputTextCell.self, forCellReuseIdentifier: inputCell)
        title = "Signup"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Continue", style: .done, target: self, action: #selector(handleSubmit))
    }
    
    func setupDefaultaAvatar() {
        //let pixelView = PixelView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
//        let image = UIImage.imageWithView(pixelView)
        //UserManager.updateProfilePic(image: image)
    }
    
    @objc func handleSubmit() {
        UserService.signup(name: name, email: email, password: password) { (success) in
             if !success {
                self.presentAlert(title: "Error", message: "Something went wrong. Please try again.")
                return
            }
            self.setupDefaultaAvatar()
            let vc = UsernameController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
        switch indexPath.row{
        case 0:
            cell.valueInput.keyboardType = .twitter
            cell.valueInput.autocorrectionType = .no
            cell.valueInput.autocapitalizationType = .words
            let placeholder = NSAttributedString(string: "Name", attributes: [NSAttributedStringKey.foregroundColor:Theme.gray])
            cell.valueInput.attributedPlaceholder = placeholder
        case 1:
            cell.valueInput.keyboardType = .emailAddress
            cell.valueInput.autocorrectionType = .no
            cell.valueInput.autocapitalizationType = .none
            let placeholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor:Theme.gray])
            cell.valueInput.attributedPlaceholder = placeholder
        case 2:
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
        switch indexPath.row {
        case 0:
            name = value
        case 1:
            email = value
        case 2:
            password = value
        default:
            break
        }
    }
    
    
}
