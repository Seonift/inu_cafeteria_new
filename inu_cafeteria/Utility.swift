//
//  Utility.swift
//  class_pick
//
//  Created by SeonIl Kim on 2017. 5. 19..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import Foundation
import UIKit

let userPreferences = UserDefaults.standard
// "id" : id. String
// "pw" : pw. String
// "auto_login" : 자동로그인 여부. Bool

//let device_width = UIScreen.main.bounds.size.width
//let device_height = UIScreen.main.bounds.size.height

class Utility {
    
    static func showFont(){
//        KoPubDotum_Pro
//            == KoPubDotumPM
//            == KoPubDotumPL
//            == KoPubDotumPB
        
        
        for family: String in UIFont.familyNames
        {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
    }
    
//    func setStatusBarBackgroundColor(color: UIColor) {
//        
//        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
//        
//        statusBar.backgroundColor = color
//    }

}
