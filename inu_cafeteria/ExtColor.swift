//
//  Color.swift
//  class_pick
//
//  Created by SeonIl Kim on 2017. 4. 15..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import UIKit

extension UIColor {
    // UIColor(hex: 0xffffff) 와 같은형식으로
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
    class func duskColor() -> UIColor {
        return UIColor(red: 84/255, green: 65/255, blue: 111/255, alpha: 1.0)
    }
    class func mediumPink() -> UIColor {
        return UIColor(red: 240/255, green: 78/255, blue: 119/255, alpha: 1.0)
    }
    
    class func pagecontroldisable() -> UIColor {
        return UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha : 1.0)
    }
    
    convenience init(rgb: CGFloat){
        self.init(red: rgb / 255, green: rgb / 255, blue: rgb / 255, alpha : 1.0)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }


}

extension UIColor {
    class var untGreyishBrown: UIColor {
        return UIColor(red: 89.0 / 255.0, green: 88.0 / 255.0, blue: 76.0 / 255.0, alpha: 1.0)
    }
}
