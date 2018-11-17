//
//  SwipeController.swift
//  Chatter
//
//  Created by Hackr on 8/22/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

//protocol SwipeDelegate {
//    func dismissSearch()
//}

import Foundation
import SwipeMenuViewController

class SwipeController: SwipeMenuViewController {
    
    var navController: UINavigationController?
    
    var query: String = "" {
        didSet {
            postsVC.queryString = query
            usersVC.queryString = query
        }
    }
    
    var searchBar: UISearchBar?
    
    convenience init(query: String) {
        self.init()
        self.query = query
        viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        searchBar?.endEditing(true)
    }
    
    private var controllers: [UIViewController]!
    
    var titles: [String] = ["People", "Posts"]
    
    var options = SwipeMenuViewOptions()
    
    override func viewDidLoad() {
        addControllers()
        super.viewDidLoad()
        view.backgroundColor = .white
        swipeMenuView.reloadData(options: options, default: 0, isOrientationChange: false)
    }
    
    var postsVC: HashtagController!
    var usersVC: UsersController!
    
    func addControllers() {
        var index = 0
        postsVC = HashtagController()
        postsVC.queryString = query
        postsVC.navController = self.navController
        
        usersVC = UsersController(style: .plain)
        usersVC.queryString = query
        usersVC.navController = self.navController
        
        controllers = [postsVC, usersVC]
        controllers.forEach { vc in
            switch index {
            case 0:
                vc.title = "Popular"
            case 1:
                vc.title = "Users"
            default:
                break
            }
            index += 1
            self.addChildViewController(vc)
        }
        
        options.tabView.height                          = 38.0
        options.tabView.margin                          = 12.0
        options.tabView.backgroundColor                 = .white
        options.tabView.style                           = .flexible
        options.tabView.itemView.font                   = Theme.bold(22)
        options.tabView.itemView.textColor              = Theme.lightGray
        options.tabView.itemView.selectedTextColor      = Theme.charcoal
        options.contentScrollView.backgroundColor       = Theme.lightBackground
        options.tabView.addition                        = .underline
        options.tabView.additionView.underline.height   = 3.0
        
    }
    
    
    // Mark: SwipeMenuDelegate
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewWillSetupAt currentIndex: Int) {
        super.swipeMenuView(swipeMenuView, viewWillSetupAt: currentIndex)
        print("will setup SwipeMenuView")
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewDidSetupAt currentIndex: Int) {
        super.swipeMenuView(swipeMenuView, viewDidSetupAt: currentIndex)
        print("did setup SwipeMenuView")
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, willChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        super.swipeMenuView(swipeMenuView, willChangeIndexFrom: fromIndex, to: toIndex)
        print("will change from section\(fromIndex + 1)  to section\(toIndex + 1)")
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        super.swipeMenuView(swipeMenuView, didChangeIndexFrom: fromIndex, to: toIndex)
        print("did change from section\(fromIndex + 1)  to section\(toIndex + 1)")
    }
    
    // Mark: SwipeMenuDataSource
    
    override func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return 2
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return childViewControllers[index].title ?? ""
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        let vc = childViewControllers[index]
        vc.didMove(toParentViewController: self)
        return vc
    }

    func dismissSearch() {
        print("Dismiss called on swipe controller")
    }
    
}
