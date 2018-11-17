//
//  ComposeController.swift
//  Sparrow
//
//  Created by Hackr on 7/28/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit
import UITextView_Placeholder
import Photos
import SwiftLinkPreview
import NextGrowingTextView

class ComposeController: UIViewController, ComposeDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, StatusLinkDelegate {
    
    let slp = SwiftLinkPreview(session: URLSession.shared,
                               workQueue: SwiftLinkPreview.defaultWorkQueue,
                               responseQueue: DispatchQueue.main,
                               cache: DisabledCache.instance)
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    var inReplyTo: Status?
    
    convenience init(inReplyTo: Status) {
        self.init()
        self.inReplyTo = inReplyTo
    }
    
    convenience init(_ username: String) {
        self.init()
        inputTextView.textView.text = "@\(username) "
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        scrollView.keyboardDismissMode = .interactive
        inputTextView.textView.delegate = self
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 32))
        view.setTitle("Share", for: .normal)
        view.titleLabel?.font = Theme.bold(16)
        view.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        view.layer.cornerRadius = 16
        view.backgroundColor = Theme.highlight
        view.setTitleColor(Theme.white, for: .normal)
        let send = UIBarButtonItem(customView: view)
        self.navigationItem.rightBarButtonItem = send
    }
    
    var previousLink: String = ""
    var link: String?
    var linkImage: String?
    var linkTitle: String?
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.frame.size.height = 240
            scrollView.contentSize.height += 240
            inputTextView.center.y += 240
        }
    }
    
    func setupLinkView(urlString: String) {
        previousLink = link!
        linkView.isHidden = false
        linkView.dismissButton.isHidden = false
            slp.previewLink(urlString, onSuccess: { (data) in
                guard let title = data["title"] as? String,
                let image = data["image"] as? String else { return }
                DispatchQueue.main.async {
                    self.presentLinkPreview(title: title, image: image)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
    }
    
    func presentLinkPreview(title: String, image: String) {
        linkTitle = title
        linkImage = image
        
        linkView.title = title
        linkView.imageUrl = image
    }
    
    func hideLinkView() {
        linkView.isHidden = true
        linkView.dismissButton.isHidden = true
    }
    
    lazy var scrollView: UIScrollView = {
        let frame = UIScreen.main.bounds
        let view = UIScrollView(frame: frame)
        view.alwaysBounceVertical = true
        view.backgroundColor = Theme.darkBackground
        view.contentSize = CGSize(width: frame.width, height: frame.height)
        return view
    }()
    
    let inputTextView: NextGrowingTextView = {
        let view = NextGrowingTextView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120))
        view.textView.placeholder = "What's happening?"
        view.textView.placeholderColor = Theme.gray
        view.textView.font = Theme.medium(20)
        view.textView.textColor = .white
        view.textView.textContainerInset = UIEdgeInsetsMake(20, 10, 0, 10)
        view.textView.keyboardType = .twitter
        view.textView.keyboardAppearance = .dark
        view.isScrollEnabled = false
        
        view.maxNumberOfLines = 12
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy var linkView: StatusLinkViewSmall = {
        let view = StatusLinkViewSmall(frame: CGRect(x: 16, y: 140, width: self.view.frame.width-32, height: 100))
        view.layer.borderColor = Theme.border.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 16
        view.isHidden = true
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        _ = inputTextView.becomeFirstResponder()
    }
    
    lazy var toolBar: ComposeToolbar = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        let bar = ComposeToolbar(frame: frame)
        bar.inputDelegate = self
        return bar
    }()
    
    
    override var inputAccessoryView: UIView! {
        get {
            return toolBar
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func handleCancel() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        view.addSubview(scrollView)
        scrollView.addSubview(inputTextView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(linkView)
        
        linkView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16).isActive = true
        linkView.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 20).isActive = true
        linkView.widthAnchor.constraint(equalToConstant: view.frame.width-32).isActive = true
        linkView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let url = detectLinks(string: textView.text) {
            link = url.standardized.absoluteString
            if previousLink != link! {
                setupLinkView(urlString: url.absoluteString)
            }
        } else {
            hideLinkView()
        }
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
    
    
    func handlePhotoIconTap() {
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
            self.image = selectedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleSend() {
        let text = removeLinks(string: inputTextView.textView.text)
        if image != nil {
            NewsService.postStatusWithPhoto(text: text, image: image!)
        } else {
            NewsService.postStatus(inReplyTo: inReplyTo, text: text, link: link, linkImage: linkImage, linkTitle: linkTitle)
        }
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    

    func dismissLinkView() {
        hideLinkView()
    }
    
    
}
