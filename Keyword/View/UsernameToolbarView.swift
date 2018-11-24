//
//  UsernameToolbarCollectionView.swift
//  Keyword
//
//  Created by Hackr on 11/23/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit

protocol UsernameToolbarDelegate {
    func usernameTapped(_ username: String)
}

class UsernameToolbarView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: UsernameToolbarDelegate?
    var spinner: UIActivityIndicatorView!
    
    var username: String = ""
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let view = UICollectionView(frame: frame, collectionViewLayout: layout)
        view.backgroundColor = Theme.cellBackground
        view.alwaysBounceHorizontal = true
        return view
    }()
    
    let usernameCell = "usernameCell"
    
    var users: [User] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UsernameCell.self, forCellWithReuseIdentifier: usernameCell)
        addSubview(collectionView)
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        spinner.frame = CGRect(x: 0, y: 0, width: frame.width, height: 64)
        spinner.tintColor = Theme.lightGray
        collectionView.backgroundView = spinner
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: usernameCell, for: indexPath) as! UsernameCell
        cell.user = users[indexPath.row]
        cell.backgroundColor = Theme.tintColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let username = users[indexPath.row].username else { return }
        delegate?.usernameTapped(username)
    }

}
