//
//  RecoveryController.swift
//  Chatter
//
//  Created by Hackr on 9/4/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit
import Firebase

class RecoveryController: UITableViewController, InputTextCellDelegate {
    
    let inputCell = "inputCell"
    var mnemonic = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(InputTextCell.self, forCellReuseIdentifier: inputCell)
        title = "Secret Phrase"
        tableView.backgroundColor = Theme.darkBackground
        tableView.separatorColor = Theme.border
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(handleSubmit))
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSubmit() {
        WalletService.generateKeyPair(mnemonic: mnemonic) { (keyPair) in
            let publicKey = keyPair.accountId
            guard let privateSeed = keyPair.secretSeed else { return }
            
            print("PUBLIC KEY: \(publicKey)")
            print("PRIVATE KEY: \(privateSeed)")
            
            KeychainHelper.publicKey = publicKey
            KeychainHelper.privateSeed = privateSeed
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
        cell.valueInput.autocorrectionType = .no
        cell.valueInput.autocapitalizationType = .none
        let placeholder = NSAttributedString(string: "Secret phrase", attributes: [NSAttributedStringKey.foregroundColor:Theme.gray])
        cell.valueInput.attributedPlaceholder = placeholder
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    func textFieldDidChange(indexPath: IndexPath, value: String) {
        mnemonic = value
    }
    
    
}

