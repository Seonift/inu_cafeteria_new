//
//  UserPreferences.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2018. 2. 22..
//  Copyright © 2018년 appcenter. All rights reserved.
//

import Foundation

let userPreferences = UserDefaults.standard

extension UserDefaults {
    
    private var _barcode: String {
        return "barcode"
    }
    
    private var _token: String {
        return "token"
    }
    
    private var _allNoticeId: String {
        return "allId"
    }
    
    private var _iOSNoticeId: String {
        return "iOSId"
    }
    
    private var _brightness: String {
        return "brightness"
    }
    
    private var _sno: String {
        return "sno"
    }
    
    open func removeAllUserDefaults() {
        userPreferences.removeObject(forKey: _barcode)
        userPreferences.removeObject(forKey: _token)
        userPreferences.removeObject(forKey: _brightness)
        userPreferences.removeObject(forKey: _sno)
        
//        let appDomain = Bundle.main.bundleIdentifier
//        userPreferences.removePersistentDomain(forName: appDomain!)
//
//        userPreferences.set(true, forKey: "not_first")
    }
    
    open func saveBarcode(barcode: String) {
        userPreferences.setValue(barcode, forKey: _barcode)
    }
    
    open func getBarcode() -> String? {
        if let b = userPreferences.string(forKey: _barcode) {
            print(b)
            return b
        }
        return nil
    }
    
    open func saveToken(token: String) {
        userPreferences.setValue(token, forKey: _token)
    }
    
    open func getToken() -> String? {
        if let t = userPreferences.string(forKey: _token) {
            return t
        }
        return nil
    }
    
    open func isToken() -> Bool {
        if userPreferences.object(forKey: _token) != nil {
            return true
        }
        return false
    }
    
    open func allNoticeCheck(id: Int) -> Bool {
        // true면 공지 띄우고, 아니면 안띄움
        if let currentId = userPreferences.object(forKey: _allNoticeId) as? Int {
            if id > currentId {
                // 공지 띄우기
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    open func setAllNoticeId(id: Int) {
        userPreferences.setValue(id, forKey: _allNoticeId)
    }
    
    open func iOSNoticeCheck(id: Int) -> Bool {
        // true면 공지 띄우고, 아니면 안띄움
        if let currentId = userPreferences.object(forKey: _iOSNoticeId) as? Int {
            if id > currentId {
                // 공지 띄우기
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    open func setiOSNoticeId(id: Int) {
        userPreferences.setValue(id, forKey: _iOSNoticeId)
    }
    
    open func isFirstStart() -> Bool {
        // true면 최초 실행
        if userPreferences.object(forKey: "not_first") == nil {
            userPreferences.setValue(true, forKey: "not_first")
            return true
        } else {
            return false
        }
    }
    
    open func saveBrightness() {
        log.info(UIScreen.main.brightness)
        if UIScreen.main.brightness == 1.0 {
            removeBrightness()
        } else {
            userPreferences.setValue(UIScreen.main.brightness, forKey: _brightness)
        }
    }
    
    open func getBrightness() -> CGFloat? {
        if let bright = userPreferences.object(forKey: _brightness) as? Float {
            if bright == 1.0 {
                return nil
            }
            return CGFloat(bright)
        }
        return nil
    }
    
    open func removeBrightness() {
        userPreferences.removeObject(forKey: _brightness)
    }
    
    open func saveSNO(sno: String) {
        userPreferences.setValue(sno, forKey: _sno)
    }
    
    open func getSNO() -> String? {
        if let sno = userPreferences.object(forKey: _sno) as? String {
            return sno
        }
        return nil
    }
}
