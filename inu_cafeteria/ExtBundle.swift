//
//  ExtBundle.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 8. 29..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import Foundation

extension Bundle {
    var versionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
