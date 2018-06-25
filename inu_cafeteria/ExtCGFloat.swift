//
//  ExtCGFloat.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 6. 25..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import Foundation
import Device

extension CGFloat {
    static var drawer_width: CGFloat {
        //        return 240.0
        return Device.getWidth(width: 240)
    }
}
