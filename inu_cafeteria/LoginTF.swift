//
//  LoginTF.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 3. 4..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import UIKit
import Device

class LoginTF: UITextField {
    
    override func awakeFromNib() {
        commonInit()
    }
    
    func commonInit() {
        setBorder()
        
        self.font = UIFont(name: "KoPubDotumPM", size: 16)
        self.textColor = UIColor.white
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.KoPubDotum(type: .M, size: 16)]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributes)
        
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        self.leftViewMode = .always
        self.rightViewMode = .always
    }
    
    func setBorder() {
        let border = CALayer()
        let height: CGFloat = 2.0
        let width = Device.getWidth(width: 200)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 5, y: self.frame.size.height - height, width: width, height: self.frame.size.height)
        border.borderWidth = height
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
