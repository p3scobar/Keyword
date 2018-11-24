//
//  SecurityController.swift
//  Sparrow
//
//  Created by Hackr on 8/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import UIKit
import Firebase

class SecurityController: UITableViewController {
    
    let standardCell = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: standardCell)
        title = "Security"
        tableView.backgroundColor = Theme.darkBackground
        tableView.separatorColor = Theme.border
        tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            pushEmailController()
        case (0,1):
            pushPasswordController()
        case (1,0):
            pushBlockedUsersController()
        default:
            break
        }
    }
    
    
    func pushEmailController() {
        let vc = EmailController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushPasswordController() {
        let vc = PasswordController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func pushBlockedUsersController() {
        let vc = BlockedUsersController(style: .plain)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: standardCell, for: indexPath)
        let background = UIView()
        cell.backgroundColor = Theme.cellBackground
        background.backgroundColor = Theme.darkBackground
        cell.selectedBackgroundView = background
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = Theme.medium(20)
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            cell.textLabel?.text = "Email"
        case (0,1):
            cell.textLabel?.text = "Password"
        case (1,0):
            cell.textLabel?.text = "Blocked Users"
        default:
            break
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
}
