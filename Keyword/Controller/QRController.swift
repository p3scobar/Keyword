//
//  QRController.swift
//  Chatter
//
//  Created by Hackr on 9/4/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit
import QRCode

class QRController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.tintColor
        setupView()
        setQRCode()
    }
    
    func setQRCode() {
        let publicKey = KeychainHelper.publicKey
        publicKeyLabel.text = publicKey
        let qrCode = QRCode(publicKey)
        qrView.image = qrCode?.image
    }
    
    
    lazy var container: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width-40, height: 480))
        view.backgroundColor = .white
        view.layer.cornerRadius = 32
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowRadius = 16
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    lazy var qrView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = Theme.semibold(20)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let line0: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let publicKeyLabel: UITextView = {
        let view = UITextView()
        view.textAlignment = .center
        view.isEditable = false
        view.font = Theme.semibold(18)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let copyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Copy", for: .normal)
        button.titleLabel?.font = Theme.bold(20)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleCopy), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let line1: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var scanButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        let scanIcon = UIImage(named: "scan")?.withRenderingMode(.alwaysTemplate)
        button.setImage(scanIcon, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleScanButtonTap), for: .touchUpInside)
        return button
    }()
    
    @objc func handleScanButtonTap() {
//        let vc = ScanController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCopy() {
        UIPasteboard.general.string = KeychainHelper.publicKey
        //        UIDevice.vibrate()
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        view.addSubview(container)
        container.addSubview(qrView)
        container.addSubview(publicKeyLabel)
        container.addSubview(doneButton)
        container.addSubview(copyButton)
        container.addSubview(line0)
        container.addSubview(line1)
        //view.addSubview(scanButton)
        
        container.center.x = view.center.x
        
        qrView.topAnchor.constraint(equalTo: container.topAnchor, constant: 40).isActive = true
        qrView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -60).isActive = true
        qrView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 60).isActive = true
        qrView.heightAnchor.constraint(equalToConstant: container.frame.width-120).isActive = true
        
        publicKeyLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        publicKeyLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        publicKeyLabel.topAnchor.constraint(equalTo: qrView.bottomAnchor, constant: 12).isActive = true
        publicKeyLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        line0.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        line0.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        line0.bottomAnchor.constraint(equalTo: copyButton.topAnchor).isActive = true
        line0.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        copyButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        copyButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        copyButton.bottomAnchor.constraint(equalTo: line1.topAnchor).isActive = true
        copyButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        line1.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        line1.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        line1.bottomAnchor.constraint(equalTo: doneButton.topAnchor).isActive = true
        line1.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        doneButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        doneButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
//        scanButton.center.x = view.center.x
//        scanButton.center.y = view.frame.height-80
        
    }
    
}

