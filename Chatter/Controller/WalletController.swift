//
//  WalletController.swift
//  Chatter
//
//  Created by Hackr on 9/4/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit
import Foundation
//import SwiftySound

class WalletController: UITableViewController, WalletHeaderDelegate {
    
    var paymentCell = "paymentCell"
    let refresh = UIRefreshControl()
    
    var payments = [Payment]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.setupEmptyView()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    lazy var header: WalletHeaderView = {
        let view = WalletHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 180))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.delegate = self
        tableView.backgroundColor = Theme.darkBackground
        tableView.refreshControl = refresh
        self.navigationItem.title = "Wallet"
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = header
        tableView.tableFooterView = UIView()
        tableView.register(PaymentCell.self, forCellReuseIdentifier: paymentCell)
        refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        extendedLayoutIncludesOpaqueBars = true
        checkForPublicKey()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let publicKey = KeychainHelper.publicKey
        let privateSeed = KeychainHelper.privateSeed
        
        print("Public Key: \(publicKey)")
        print("Private Seed: \(privateSeed)")
    }
    
    func checkForPublicKey() {
        if KeychainHelper.publicKey != "" {
            loadData()
        } else {
            header.balance = "Create New Wallet"
            header.currencyCodeLabel.text = "Backup Passphrase"
            setupEmptyView()
        }
    }
    
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: 80))
        label.text = "No transactions."
        label.textColor = Theme.gray
        label.font = Theme.semibold(18)
        label.textAlignment = .center
        return label
    }()
    
    func setupEmptyView() {
        if payments.count == 0 {
            self.tableView.backgroundView = emptyLabel
        } else {
            self.tableView.backgroundView = nil
        }
    }
    
    
    func fetchTransactions() {
        WalletService.fetchTransactions { (payments) in
            self.payments = payments
        }
    }
    
    func streamTransactions() {
        WalletService.streamPayments { (payment) in
            self.payments.insert(payment, at: 0)
            self.getAccountDetails()
        }
    }
    
    @objc func pullToRefresh() {
        if Model.shared.soundsEnabled {
            DispatchQueue.main.async {
                //Sound.play(file: "expand.m4a")
            }
        }
        if KeychainHelper.publicKey != "" {
            getAccountDetails()
            fetchTransactions()
        } else {
            refreshControl?.endRefreshing()
        }
    }
    
    
    func getAccountDetails() {
        WalletService.getAccountDetails { (balance) in
            DispatchQueue.main.async {
                self.header.balance = balance
                self.header.currencyCodeLabel.text = "SGR"
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    @objc func loadData() {
        getAccountDetails()
        fetchTransactions()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: paymentCell, for: indexPath) as! PaymentCell
        let background = UIView()
        background.backgroundColor = Theme.darkBackground
        cell.selectedBackgroundView = background
        cell.payment = payments[indexPath.row]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let payment = payments[indexPath.row]
        presentReceiptController()
//                let vc = TransactionController(payment: payment)
//                self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func handleQRTap() {
        if KeychainHelper.publicKey == "" {
            presentMnemonicController()
        } else if KeychainHelper.privateSeed == "" {
            presentRecoveryController()
        } else {
            presentQRController()
        }
    }
    
    func presentReceiptController() {
        definesPresentationContext = true
//        let vc = ReceiptController()
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overCurrentContext
//        self.tabBarController?.present(vc, animated: true, completion: nil)
    }
    
    func presentQRController() {
        self.definesPresentationContext = true
        let vc = QRController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .crossDissolve
        present(nav, animated: true, completion: nil)
    }
    
    func presentMnemonicController() {
        let vc = MnemonicController(style: .plain)
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    func presentRecoveryController() {
        let vc = RecoveryController(style: .plain)
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    
}


