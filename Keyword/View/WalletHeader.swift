//
//  WalletHeader.swift
//  Chatter
//
//  Created by Hackr on 9/4/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import Foundation
import UIKit
import QRCode

protocol WalletHeaderDelegate: class {
    func handleQRTap()
}

class WalletHeaderView: UIView {
    
    var delegate: WalletHeaderDelegate?
    
    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = NSLocale.current
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        return formatter
    }()
    
    var balance: String = "Wallet" {
        didSet {
            if let number = formatter.number(from: balance),
                let string = formatter.string(from: number) {
                balanceLabel.text = string
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setQRCode()
    }
    
    func setQRCode() {
        let publicKey = KeychainHelper.publicKey
        let qrCode = QRCode(publicKey)
        qrView.image = qrCode?.image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .black
        label.font = Theme.bold(24)
        label.text = "0.000"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.text = "KEY"
        label.font = Theme.medium(18)
        label.textColor = Theme.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var shadow: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.shadowColor = Theme.darkBackground.cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var qrView: UIImageView = {
        let frame = CGRect(x: 0, y: 0, width: 72, height: 72)
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    @objc func handleQRTap() {
        delegate?.handleQRTap()
    }
    
    func setupView() {
        backgroundColor = Theme.darkBackground
        addSubview(shadow)
        addSubview(container)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleQRTap))
        container.addGestureRecognizer(tap)
        container.addSubview(balanceLabel)
        container.addSubview(currencyCodeLabel)
        container.addSubview(qrView)
        
        shadow.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        shadow.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        shadow.heightAnchor.constraint(equalToConstant: 100).isActive = true
        shadow.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        
        container.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        container.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        container.heightAnchor.constraint(equalToConstant: 100).isActive = true
        container.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        
        qrView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        qrView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        qrView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        qrView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        balanceLabel.leftAnchor.constraint(equalTo: qrView.leftAnchor).isActive = true
        balanceLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        balanceLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -16).isActive = true
        balanceLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        currencyCodeLabel.leftAnchor.constraint(equalTo: balanceLabel.leftAnchor).isActive = true
        currencyCodeLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        currencyCodeLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 20).isActive = true
        currencyCodeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
}

