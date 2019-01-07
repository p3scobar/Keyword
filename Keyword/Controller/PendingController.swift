//
//  PendingController.swift
//  Chatter
//
//  Created by Hackr on 9/4/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit
//import MaterialActivityIndicator

class PendingController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.darkBackground
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    let indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = Theme.lightGray
        return view
    }()
    
    convenience init(mnemonic: String) {
        self.init()
        DispatchQueue.global(qos: .background).async {
            WalletService.generateKeyPair(mnemonic: mnemonic) { (keyPair) in
                let publicKey = keyPair.accountId
                guard let privateSeed = keyPair.secretSeed else { return }
                KeychainHelper.publicKey = publicKey
                KeychainHelper.privateSeed = privateSeed
                
                UserService.updatePublicKey(pk: publicKey, completion: { (_) in })
                
                WalletService.createStellarTestAccount(accountID: publicKey, completion: { (response) in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    convenience init(accountId: String, username: String, amount: Decimal) {
        self.init()
        setupView()
        WalletService.sendPayment(accountId: accountId, amount: amount) { (success) in
            if success {
                self.presentAlert(title: "Success", message: "You sent \(amount) KEY to @\(username.lowercased())")
            } else {
                self.presentAlert(title: "Transaction Failed", message: "Something went wrong. Please try again.")
            }
        }
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .default) { (done) in
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupView() {
        view.addSubview(indicator)
        
        indicator.widthAnchor.constraint(equalToConstant: 60).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 60).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        indicator.startAnimating()
    }
}

