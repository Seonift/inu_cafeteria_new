//
//  ExtTextfield.swift
//  class_pick
//
//  Created by SeonIl Kim on 2017. 7. 11..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import UIKit

extension UITextField {
    func setHint(hint:String, font:UIFont, textcolor:UIColor) {
        let attributes = [
            NSForegroundColorAttributeName: textcolor,
            NSFontAttributeName : font
        ]
        attributedPlaceholder = NSAttributedString(string: hint, attributes:attributes)
    }
}
