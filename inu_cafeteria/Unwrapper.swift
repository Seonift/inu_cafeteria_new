//
//   Unwrapper.swift
//  SmartCampus
//
//  Created by BLU on 2017. 3. 24..
//  Copyright © 2017년 INUAPPCENTER. All rights reserved.
//

import UIKit

// 옵셔널 처리시 비강제 해제
func gsno(_ value: String?) -> String {
    if let value_ = value {
        return value_
    } else {
        return ""
    }
}

func gino(_ value: Int?) -> Int {
    guard let value_ = value else {
        return 0
    }
    return value_
}

func gfno(_ value: Float?) -> Float {
    guard let value_ = value else {
        return 0
    }
    return value_
}
