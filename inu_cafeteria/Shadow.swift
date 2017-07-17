//
//  Shadow.swift
//  class_pick
//
//  Created by SeonIl Kim on 2017. 4. 16..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import UIKit

//extension UIViewController {
//    
//    
//}

struct Shadow {
    
    // Shadow().setShadow(view)
    func setShadow(_ sender: UIView) {
        sender.layer.borderWidth = 1
        sender.layer.borderColor = UIColor(r: 240, g: 240, b: 240).cgColor
        sender.layer.masksToBounds = false
        sender.layer.cornerRadius = 5
        sender.layer.shadowOffset = CGSize(width: 1, height: 0)
        sender.layer.shadowColor = UIColor(r: 240, g: 240, b: 240).cgColor
        sender.layer.shadowRadius = 3
        sender.layer.shadowOpacity = 1
    }
    
    func setKeyWindowShadow(_ sender: UIView, cornerRadius: CGFloat) {
        sender.layer.borderWidth = 1
        sender.layer.borderColor = UIColor(r: 240, g: 240, b: 240).cgColor
        sender.layer.masksToBounds = false
        sender.layer.cornerRadius = cornerRadius
//        sender.layer.shadowOffset = CGSize(width: 1, height: 5)
//        sender.layer.shadowColor = UIColor(r: 240, g: 240, b: 240).cgColor
//        sender.layer.shadowRadius = cornerRadius - 2
//        sender.layer.shadowOpacity = 1
    }
}
