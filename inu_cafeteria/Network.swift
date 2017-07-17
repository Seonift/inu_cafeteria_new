//
//  Network.swift
//  class_pick
//
//  Created by SeonIl Kim on 2017. 5. 19..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import Foundation

struct Network {
    
    func saveCookie() {
        let cookies: [Any] = HTTPCookieStorage.shared.cookies!
        let cookieData = NSKeyedArchiver.archivedData(withRootObject: cookies)
        UserDefaults.standard.set(cookieData, forKey: "Cookies")
    }
    
    func getCookie() {
        var cookiesData: Data? = UserDefaults.standard.object(forKey: "Cookies") as? Data
        if ((cookiesData?.count) != nil) {
            let cookies: [HTTPCookie]? = NSKeyedUnarchiver.unarchiveObject(with: cookiesData!) as? [HTTPCookie]
            for cookie: HTTPCookie in cookies! {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
    }
}
