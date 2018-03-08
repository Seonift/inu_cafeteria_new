//
//  LoginModel.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 22..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class LoginModel: NetworkModel {
    
    let _login = "login"
    let _cafecode = "cafecode.json"
    let _logout = "logout"
    let _version = "version.json"
    let _notice = "notice.json"
    
    func login(sno: String, pw: String, auto: Bool) {
        Indicator.startAnimating(activityData)
        
        let params = [
            "sno": sno,
            "pw": pw,
            "auto": auto ? "1" : "0",
            "device": "ios"
        ]
        userPreferences.saveSNO(sno: sno)
        post(function: _login, type: LoginObject.self, params: params)
    }
    
    func login() {
        // 자동로그인
        if let token = userPreferences.getToken() {
            let params = [
                "token": token
            ]
            post(function: _login, type: LoginObject.self, params: params)
        } else {
            self.view?.networkFailed(errorMsg: String.noToken, code: _login)
        }
    }
    
    func cafecode() {
        get(function: _cafecode, type: CafeCode.self)
    }
    
    func logout() {
        if let token = userPreferences.getToken() {
            let params = [
                "token": token
            ]
            post(function: _logout, params: params)
        } else {
            self.view?.networkResult(resultData: true, code: _logout)
        }
        userPreferences.removeAllUserDefaults()
    }
    
    func version() {
        get(function: _version, type: VerObject.self)
    }
    
    func notice() {
        get(function: _notice, type: NoticeObject.self)
    }
}
