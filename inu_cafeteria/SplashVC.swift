//
//  SplashVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 21..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import KYDrawerController
import Toaster

class SplashVC: UIViewController {
    
    var delayInSeconds = 2.0
    
    override func viewDidLoad() {
        
//        userPreferences.set(false, forKey: "auto_login")
        
        
        //서버 접속 불가일 때랑 인터넷 연결 안될경우 예외처리 필요함
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            if userPreferences.bool(forKey: "auto_login") == true && userPreferences.object(forKey: "dtoken") != nil {
                let model = LoginModel(self)
                model.autologin()
            } else {
                let main_storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let main = main_storyboard.instantiateViewController(withIdentifier: "firststartvc") as? FirstStartVC else {return}
                self.present(main, animated: false, completion: nil)
            }
        }//DispatchQueue.main.async
    }
    
    override func networkResult(resultData: Any, code: String) {
//        if code == "login" {
//            let result = resultData as! Bool
//            if result == true {
//                self.showHome()
//            }
//        }
        
        if code == "auto_login" {
            let result = resultData as! Bool
            if result == true {
                self.showHome()
            }
        }
    }
    
    override func networkFailed(code: Any) {
        failAutoLogin()
    }
    
    override func networkFailed() {
        failAutoLogin()
    }
    
    func failAutoLogin(){
        userPreferences.removeObject(forKey: "auto_login")
        userPreferences.removeObject(forKey: "dtoken")
        
        Toast(text: "로그인에 실패했습니다.").show()
        
        let main_storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let main = main_storyboard.instantiateViewController(withIdentifier: "firststartvc") as? FirstStartVC else {return}
        self.present(main, animated: true, completion: nil)
    }
}
