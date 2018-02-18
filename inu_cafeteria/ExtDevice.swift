//
//  ExtDevice.swift
//  미스터빈
//
//  Created by SeonIl Kim on 2018. 2. 11..
//  Copyright © 2018년 SeonIl Kim. All rights reserved.
//

import Foundation
import Device

extension Device {
    
    static func getWidth(width: CGFloat) -> CGFloat {
        let deviceWidth = UIScreen.main.bounds.width
        if deviceWidth == 375 {
            return width
        }
        return width * (deviceWidth / 375)
    }
    
    static func getHeight(height: CGFloat) -> CGFloat {
        let deviceHeight = UIScreen.main.bounds.height
        if deviceHeight == 667 {
            return height
        }
        return height * (deviceHeight / 667)
    }
}
