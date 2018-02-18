//
//  ExtFont.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 2. 17..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import Foundation



extension UIFont {
    enum FontType {
        case B
        case M
        case L
    }
    
    static func KoPubDotum(type: FontType, size: CGFloat) -> UIFont {
        switch type {
        case .B:
            if let font = UIFont(name: "KoPubDotumPB", size: size) { return font }
        case .M:
            if let font = UIFont(name: "KoPubDotumPM", size: size) { return font }
        case .L:
            if let font = UIFont(name: "KoPubDotumPL", size: size) { return font }
        }
        
        return UIFont.systemFont(ofSize: size)
    }
}
