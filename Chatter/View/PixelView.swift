//
//  PixelView.swift
//  Sparrow
//
//  Created by Hackr on 8/2/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import UIKit
import Foundation

class PixelView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let numViewPerRow = 4
        let width = frame.width / CGFloat(numViewPerRow)
        
        for j in 0...3 {
            for i in 0...numViewPerRow {
                let view = UIView()
                view.backgroundColor = randomColor()
                view.frame = CGRect(x: CGFloat(i) * width, y: CGFloat(j) * width, width: width, height: width)
                addSubview(view)
            }
        }
    }
    
    fileprivate func randomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(256))
        let green = CGFloat(arc4random_uniform(256))
        let blue = CGFloat(arc4random_uniform(256))
        print(red)
        print(green)
        print(blue)
        
        return UIColor(red, green, blue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
