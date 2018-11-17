//
//  Tools.swift
//  Sparrow
//
//  Created by Hackr on 8/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import SafariServices
import UIKit

extension Decimal {
    
    func rounded(_ decimals: Int) -> String {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals
        return formatter.string(from: self as NSDecimalNumber) ?? ""
    }

    
    func roundedDecimal() -> Decimal {
        let number = NSDecimalNumber(decimal: self)
        let rounding = NSDecimalNumberHandler(roundingMode: .bankers, scale: 7, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        return number.rounding(accordingToBehavior: rounding).decimalValue
    }
}


internal func detectLinks(string: String) -> URL? {
    let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    let matches = detector.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
    var url: URL?
    for match in matches {
        guard let range = Range(match.range, in: string) else { continue }
        let substring = string[range]
        var components = URLComponents(string: substring.description)
        components?.scheme = "https"
        url = components?.url
    }
    return url
}

internal func removeLinks(string: String) -> String {
    let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    let matches = detector.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
    var newString = string
    for match in matches {
        guard let range = Range(match.range, in: string) else { continue }
        newString.removeSubrange(range)
    }
    return newString
}


extension String {
    var mentions: [String]? {
        get {
            var usernames: [String] = []
            let words: Array = self.components(separatedBy: " ")
            words.forEach { (word) in
                if word.hasPrefix("@") {
                    usernames.append(word)
                }
            }
            return usernames
        }
    }
}



internal func isFavorited(id: String) -> Bool {
    if Model.shared.favorites[id] == true {
        print("LIKED POST ID: \(id)")
        return true
    } else {
        return false
    }
}


extension UIView {
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = Theme.red.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 12.0
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

extension StatusCell {
    var height: CGFloat {
        get {
            var standardHeight: CGFloat = 80
            if let text = self.status?.text {
                let width = UIScreen.main.bounds.width-100
                let textHeight = text.height(forWidth: width, font: Theme.medium(18))
                standardHeight += textHeight
            }
            if self.status?.image != nil {
                standardHeight += 240
            }
            if self.status?.link != nil {
                standardHeight += 240
            }
//            if self.status?.inReplyToId != nil, replyView.isHidden == false {
//                let replyText = self.status?.inReplyToText ?? ""
//                let replyHeight = replyText.height(forWidth: UIScreen.main.bounds.width-112, font: Theme.medium(18))+60
//                standardHeight += (replyHeight <= 160) ? replyHeight : 170
//            }
            return standardHeight
        }
    }
}


extension Status {
    func height(withReply: Bool) -> CGFloat {
        var height: CGFloat = 80
        if let text = self.text {
            let width = UIScreen.main.bounds.width-100
            let textHeight = text.height(forWidth: width, font: Theme.medium(18))
            height += textHeight
        }
        if self.image != nil {
            height += 190
        }
        if self.link != nil {
            height += 240
        }
        if self.inReplyToId != nil, withReply == true, let replyText = self.inReplyToText {
            let replyHeight = replyText.height(forWidth: UIScreen.main.bounds.width-124, font: Theme.medium(18))+60
            height += (replyHeight <= 160) ? replyHeight : 170
        }
        return height
    }
    
    
    func heightLarge() -> CGFloat {
        var height: CGFloat = 220
        if let text = self.text {
            let width = UIScreen.main.bounds.width-32
            let textHeight = text.height(forWidth: width, font: Theme.regular(22))
            height += textHeight
        }
        if self.image != nil {
            height += 240
        }
        if self.link != nil {
            height += 240
        }
        if self.inReplyToId != nil, let replyText = self.inReplyToText {
            let replyHeight = replyText.height(forWidth: UIScreen.main.bounds.width-124, font: Theme.medium(18))+50
            height += (replyHeight <= 160) ? replyHeight : 170
        }
        return height
    }
}

extension NSDate {
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: self as Date)
    }
}


extension UIAlertController {
    func presentOverKeyboard(animated: Bool, completion: (() -> Void)?) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(self, animated: animated, completion: completion)
    }
}


/// Bold activity cell text

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: Theme.bold(18)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: Theme.regular(18), .foregroundColor: Theme.gray]
        let normal = NSAttributedString(string: text, attributes: attrs)
        append(normal)
        return self
    }
}


extension UIColor {
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}


internal func estimateFrameForText(width: CGFloat, text: String, fontSize: CGFloat) -> CGRect {
    let size = CGSize(width: width, height: 180)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)], context: nil)
}


internal func estimateFrameForTextWidth(width: CGFloat, text: String, fontSize: CGFloat) -> CGFloat {
    let size = CGSize(width: width, height: 280)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)], context: nil).height
}

extension String {
    func height(forWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}

