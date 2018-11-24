//
//  Theme.swift
//  Sparrow
//
//  Created by Hackr on 7/28/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit

public struct Theme {}

extension Theme {
    
    static func bold(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
    }
    
    static func semibold(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
    }
    
    static func medium(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
    }
    
    static func regular(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
    }
    
    public static var white: UIColor {
        return UIColor(255, 255, 255)
    }
    
    public static var lightGray: UIColor {
        return UIColor(220, 220, 220)
    }

//    public static var border: UIColor {
//        return UIColor(200, 200, 200)
//    }
    
    public static var gray: UIColor {
        return UIColor(125, 140, 155)
    }
    
    public static var unfilled: UIColor {
        return UIColor(31, 49, 68)
    }
    
    public static var selected: UIColor {
        return UIColor(140, 140, 140)
    }
    
    public static var charcoal: UIColor {
        return UIColor(60, 60, 60)
    }
    
    public static var darkBackground: UIColor {
        return UIColor(15, 25, 35)
    }
    
    public static var cellBackground: UIColor {
        return UIColor(20, 32, 45)
    }
    
    public static var tintColor: UIColor {
        //return UIColor(25, 41, 58)
        return UIColor(23, 37, 53)
    }
    
    public static var lightBackground: UIColor {
        return UIColor(235, 235, 241)
    }
    
    public static var red: UIColor {
        return UIColor(214, 21, 92)
    }
    
//    public static var green: UIColor {
//        return UIColor(36, 158, 85)
//    }
    
    public static var pink: UIColor {
        return UIColor(230,55,110)
    }
    
    public static var blue: UIColor {
        return UIColor(29, 161, 242)
//        return UIColor(22, 129, 247)
    }
    
    public static var highlight: UIColor {
        return UIColor(29, 161, 242)
    }
    
    public static var border: UIColor {
        return UIColor(59, 72, 87)
    }

    public static var lightGrayText: UIColor {
        return UIColor(160, 160, 160)
    }

    public static var darkText: UIColor {
        return UIColor(20, 20, 20)
    }
    
}


