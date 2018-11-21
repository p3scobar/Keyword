//
//  EditProfileController.swift
//  Sparrow
//
//  Created by Hackr on 8/4/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import UIKit

class EditProfileController: UITableViewController, UITextFieldDelegate, InputTextCellDelegate {
    
    var accountController: AccountController!
    var inputCell = "inputCell"
    var inputTextView = "inputTextView"
    
    var name: String = ""
    var bio: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = true
        tableView.alwaysBounceVertical = true
        tableView.backgroundColor = Theme.darkBackground
        tableView.separatorColor = Theme.border
        tableView.register(InputTextCell.self, forCellReuseIdentifier: inputCell)
        tableView.register(InputTextViewCell.self, forCellReuseIdentifier: inputTextView)
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        tableView.tableFooterView = UIView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
        title = "Edit Profile"
        self.name = Model.shared.name
        self.bio = Model.shared.bio
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    @objc func handleSave() {
        UserService.updateUser(name: name, bio: bio) { (success) in
            Model.shared.name = self.name
            Model.shared.bio = self.bio
            self.accountController.tableView.reloadData()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = setupCell(tableView: tableView, indexPath: indexPath)
        return cell
    }
    
    func setupCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCell, for: indexPath) as! InputTextCell
            cell.valueInput.textAlignment = .left
            cell.delegate = self
            cell.valueInput.text = Model.shared.name
            cell.indexPath = indexPath
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCell, for: indexPath) as! InputTextCell
            cell.delegate = self
            cell.valueInput.textAlignment = .left
            cell.valueInput.text = Model.shared.username
            cell.valueInput.isEnabled = false
            cell.selectionStyle = .none
            cell.indexPath = indexPath
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: inputTextView, for: indexPath) as! InputTextViewCell
            cell.delegate = self
            cell.textView.placeholder = "Write something about yourself..."
            cell.textView.text = Model.shared.bio
            cell.indexPath = indexPath
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCell, for: indexPath) as! InputTextCell
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Name"
        case 1:
            return "@Username"
        default:
            return ""
        }
    }
    
    
    func textFieldDidChange(indexPath: IndexPath, value: String) {
        switch indexPath.section {
        case 0:
            name = value
        case 2:
            bio = value
        default:
            break
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 200
        } else {
            return 72
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            presentUsernameController()
        }
    }
    
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func presentUsernameController() {
        let vc = UsernameController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func presentErrorController(message:String) {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .default)
        alert.addAction(done)
        present(alert, animated: true)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        view.endEditing(true)
    }
    
}
