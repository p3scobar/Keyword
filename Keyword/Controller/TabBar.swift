//
//  TabBar.swift
//  Sparrow
//
//  Created by Hackr on 7/27/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit

class TabBar: UITabBarController, UITabBarControllerDelegate {
    
    var timelineVC: TimelineController!
    var discoverVC: DiscoverController!
    var activityVC: ActivityController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        timelineVC = TimelineController()
        let timeline = UINavigationController(rootViewController: timelineVC)
        timeline.tabBarItem.image = UIImage(named: "iconHome")
        timeline.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -6, right: 0)
        
        discoverVC = DiscoverController(style: .plain)
        let discover = UINavigationController(rootViewController: discoverVC)
        discover.tabBarItem.image = UIImage(named: "iconSearch")
        discover.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -6, right: 0)
        
        let walletVC = WalletController(style: .grouped)
        let wallet = UINavigationController(rootViewController: walletVC)
        wallet.tabBarItem.image = UIImage(named: "qrcode")
        wallet.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -6, right: 0)
        
        activityVC = ActivityController(style: .plain)
        let activity = UINavigationController(rootViewController: activityVC)
        activity.tabBarItem.image = UIImage(named: "activity")
        activity.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -6, right: 0)
        
        let accountVC = AccountController(style: .grouped)
        let account = UINavigationController(rootViewController: accountVC)
        account.tabBarItem.image = UIImage(named: "iconUser")
        account.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -6, right: 0)
        
        viewControllers = [timeline, discover, wallet, activity, account]

        checkForNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(checkForNotifications), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationObserver), name: Notification.Name(rawValue: "notifications"), object: nil)
    }
    
    
    @objc func checkForNotifications() {
        ActivityService.fetchActivity { (notifications) in
            let unread = notifications.filter({ $0.unread == true })
            self.updateNotificationBadge(unread.count)
        }
    }
    
    @objc func handleNotificationObserver(_ notification: Notification) {
        guard let count = notification.userInfo?["count"] as? Int else { return }
        updateNotificationBadge(count)
    }
    
    func updateNotificationBadge(_ count: Int) {
        guard let item = tabBar.items?[3] else { return }
        guard count > 0 else {
            item.badgeValue = nil
            return
        }
        item.badgeColor = Theme.highlight
        item.badgeValue = "\(count)"
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let items = tabBar.items else { return }
        if Model.shared.soundsEnabled == true {
            SoundKit.playSound(type: .tab)
        }
            
        if item == items[0] {
            timelineVC.scrollToTop()
        }
        if item == items[1] {
            discoverVC.scrollToTop()
        }
        if item == items[3] {
            activityVC.scrollToTop()
            checkForNotifications()
        }
    }
    
    
    
}

