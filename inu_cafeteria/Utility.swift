//
//  Utility.swift
//  class_pick
//
//  Created by SeonIl Kim on 2017. 5. 19..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    
    static func showFont() {
//        KoPubDotum_Pro
//            == KoPubDotumPM
//            == KoPubDotumPL
//            == KoPubDotumPB

        for family: String in UIFont.familyNames {
            log.debug("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family) {
                log.debug("== \(names)")
            }
        }
    }
}
