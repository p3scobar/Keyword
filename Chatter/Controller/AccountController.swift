//
//  AccountController.swift
//  Sparrow
//
//  Created by Hackr on 7/28/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit
import MessageUI
import Photos

class AccountController: UITableViewController, MFMailComposeViewControllerDelegate, UIImagePickerControllerDelegate, MFMessageComposeViewControllerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    let standardCell = "userCell"
    
    lazy var header: AccountHeader = {
        let view = AccountHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 160))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Account"
        
        header.delegate = self
        header.tap.delegate = self
        view.backgroundColor = Theme.darkBackground
        tableView.backgroundColor = Theme.darkBackground
        tableView.separatorColor = Theme.border
        tableView.tableHeaderView = header
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: standardCell)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pushProfile))
        header.addGestureRecognizer(tap)
        extendedLayoutIncludesOpaqueBars = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        header.setupNameAndProfileImage()
    }
    
    func photoPermission() -> Bool {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        var authorized: Bool = false
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
            authorized = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                print("status is \(status)")
                if status == PHAuthorizationStatus.authorized {
                    authorized = true
                }
            })
        case .restricted:
            print("User do not have access to photo album.")
            authorized = false
        case .denied:
            print("User has denied the permission.")
            authorized =  false
        }
        return authorized
    }
    
    
    @objc func pushProfile() {
        let vc = UserController(userId: Model.shared.uuid)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 2
        default:
            return 0
        }
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
        case (0, 0):
            cell.textLabel?.text = "Settings"
        case (0, 1):
            cell.textLabel?.text = "Invite Friends"
        case (1, 0):
            cell.textLabel?.text = "Passphrase"
        case (2, 0):
            cell.textLabel?.text = "Security"
        case (2, 1):
            cell.textLabel?.text = "Sign out"
        default:
            break
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func handleEditButtonTap() {
        let vc = EditProfileController(style: .grouped)
        vc.accountController = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case(0,0):
            pushNotificationController()
        case (0, 1):
            presentInviteController()
        case (1, 0):
            presentPassphrase()
        case (2,0):
            pushSecurityController()
        case (2,1):
            confirmLogout()
        default:
            return
        }
    }
    
    func presentPassphrase() {
        let vc = MnemonicController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func pushSecurityController() {
        let vc = SecurityController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func presentInviteController() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .black
        let message = UIAlertAction(title: "Message", style: .default) { (mail) in
            self.presentMessageController()
        }
        let mail = UIAlertAction(title: "Email", style: .default) { (mail) in
            self.presentMailController()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(message)
        alert.addAction(mail)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func presentMessageController() {
        if !MFMessageComposeViewController.canSendText() {
            presentAlert(title: "iMessage Unavailable", message: "Unable to send text messages")
        } else {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.body = "Hey, you should download Sugar. Here's the link: sugar.am/ios"
        self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    
    func pushNotificationController() {
        let vc = NotificationsController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func confirmLogout() {
        let alert = UIAlertController(title: "Have you secured your recovery phrase?", message: "Without this you will not be able to recoer your account or sign back in.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let signOut = UIAlertAction(title: "Sign Out", style: .destructive) { (tap) in
            self.handleLogout()
        }
        alert.addAction(cancel)
        alert.addAction(signOut)
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleLogout() {
        UserService.signout { (loggedOut) in
            let vc = HomeController()
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true)
            self.tabBarController?.selectedIndex = 0
            let id = Model.shared.uuid
            print("User ID: \(id)")
        }
    }
    
    
    func pushProfileController() {
        let vc = UserController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        alert.addAction(doneButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentMailController() {
        if !MFMailComposeViewController.canSendMail() {
            presentAlert(title: "Email Unavailable", message: "Please setup email on your iPhone")
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.isModalInPopover = true
        composeVC.mailComposeDelegate = self
        let body = "Hey, you should download Sugar. Here's the link: sugar.am/ios"
        composeVC.setMessageBody(body, isHTML: false)
        composeVC.modalPresentationStyle = .none
        present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func handleEditProfilePic() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let picker = UIAlertAction(title: "Camera Roll", style: .default) { (alert) in
            self.presentImagePickerController()
        }
        let done = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        alert.addAction(picker)
        alert.addAction(done)
        present(alert, animated: true, completion: nil)
    }
    
    func generateNewPixel() {
//        let pixelView = PixelView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
//        let image = UIImage.imageWithView(pixelView)
//        header.profileImage.image = image
//        UserManager.updateProfilePic(image: image)
    }
    
    
    func presentImagePickerController() {
        if photoPermission() {
            let vc = UIImagePickerController()
            vc.allowsEditing = true
            vc.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            vc.modalPresentationStyle = .popover
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = originalImage as? UIImage
        }
        if let selectedImage = selectedImageFromPicker {
            UserService.updateProfilePic(image: selectedImage) { (imageUrl) in
                print(imageUrl)
                Model.shared.profileImage = imageUrl
            }
            header.profileImage.image = selectedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    
}

