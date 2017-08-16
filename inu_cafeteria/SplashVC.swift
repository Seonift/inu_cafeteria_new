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
            let model = LoginModel(self)
            model.message()
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
            let result = resultData as! [CodeObject]
            
            self.showHome(result, false)
        }
        
        if code == "message" {
            let result = resultData as! MessageObject
            let alertController = UIAlertController(title: result.title, message: result.message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) { res -> Void in
                self.showMain()
            }
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func networkFailed(code: Any) {
        failAutoLogin(code)
    }
    
    override func networkFailed() {
        failAutoLogin(nil)
    }
    
    func showMain(){
        if userPreferences.bool(forKey: "auto_login") == true && userPreferences.object(forKey: "dtoken") != nil {
            let model = LoginModel(self)
            model.autologin()
        } else {
            let main_storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let main = main_storyboard.instantiateViewController(withIdentifier: "firststartvc") as? FirstStartVC else {return}
            self.present(main, animated: false, completion: nil)
        }
    }
    
    func failAutoLogin(_ code: Any?){
        Utility.removeAllUserDefaults()
        
        if code == nil {
            Toast(text: "로그인에 실패했습니다.").show()
        } else {
            if let str = code as? String {
                if str == "no_barcode" {
                    Toast(text: "바코드 정보 오류. 다시 로그인해주세요.").show()
                }
                
                if str == "no_code" {
                    Toast(text: "식당 정보 오류. 다시 로그인해주세요.").show()
                }
                
                if str == "no_stuinfo" {
                    Toast(text: "학생 정보 오류. 다시 로그인해주세요.").show()
                }
                
                if str == "message" {
                    self.showMain()
                }
            }
        }
        
        let main_storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let main = main_storyboard.instantiateViewController(withIdentifier: "firststartvc") as? FirstStartVC else {return}
        self.present(main, animated: true, completion: nil)
    }
}
