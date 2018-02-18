//
//  SplashVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 21..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import KYDrawerController
import Toast_Swift

class SplashVC: UIViewController, NetworkCallback {
    
    var delayInSeconds = 2.0
    
    lazy var loginModel:LoginModel = {
        let model = LoginModel(self)
        return model
    }()
    
    override func viewDidLoad() {
        
//        userPreferences.set(false, forKey: "auto_login")
        
        
        //서버 접속 불가일 때랑 인터넷 연결 안될경우 예외처리 필요함
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            self.loginModel.version()
//            model.notice()
        }//DispatchQueue.main.async
    }
    
    func networkResult(resultData: Any, code: String) {
        
        if code == "version" {
            
            let result = resultData as! Bool
            
            if result == true {
                let alert = CustomAlert.okAlert(title: "업데이트", message: String.update, positiveAction: { action in
                    if let url = URL(string: "itms://itunes.apple.com/kr/app/id1336050737?mt=8"), UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url)
                        } else {
                            // Fallback on earlier versions
                            UIApplication.shared.openURL(url)
                        }
                    }
                })
                self.present(alert, animated: true, completion: nil)
//                let alertController = UIAlertController(title: "업데이트", message: String.update, preferredStyle: .alert)
//                let ok = UIAlertAction(title: "확인", style: .default) { res -> Void in
//
//                }
//                alertController.addAction(ok)
//                self.present(alertController, animated: true, completion: nil)
            } else {
                loginModel.notice()
            }
        }
        
        if code == "auto_login" {
            let result = resultData as! [CodeObject]
            
            self.showHome(result, false)
        }
        
        if code == "notice" {
            let result = resultData as! Notices
            
            
            if userPreferences.object(forKey: "notice") == nil || !isDateToday(userPreferences.object(forKey: "notice") as! Date) {
                //저장된 날짜가 없으면 다이얼로그 출력
                //오늘 보인적이 없으면 보이기
                showDialog(result)
            } else {
                self.showMain()
            }
            
        }
    }
    
    func isDateToday(_ date: Date) -> Bool {
        //true면 오늘 날짜
        let today = Date()
        
        if Calendar.current.compare(date, to: today, toGranularity: .day) == .orderedSame {
            return true
        }
        return false
    }
    
    func showDialog(_ result: Notices){
        if result.all?.message != nil && result.all?.message != "" {
            let alert = CustomAlert.noticeAlert(title: result.all?.title, message: result.all?.message, firstAction: { action in
                self.showMain()
            }, secondAction: { action in
                userPreferences.setValue(Date(), forKey: "notice")
                self.showMain()
            })
            self.present(alert, animated: true, completion: nil)
            
//            let alertController = UIAlertController(title: result.all?.title, message: result.all?.message, preferredStyle: .alert)
//            let ok = UIAlertAction(title: "확인", style: .default) { res -> Void in
//
//            }
//            let ok2 = UIAlertAction(title: "오늘하루안보기", style: .default) { res -> Void in
//
//            }
//            alertController.addAction(ok)
//            alertController.addAction(ok2)
//            self.present(alertController, animated: true, completion: nil)
        } else if result.ios?.message != nil && result.ios?.message != "" {
            let alert = CustomAlert.noticeAlert(title: result.ios?.title, message: result.ios?.message, firstAction: { action in
                self.showMain()
            }, secondAction: { action in
                userPreferences.setValue(Date(), forKey: "notice")
                self.showMain()
            })
            self.present(alert, animated: true, completion: nil)
            
//            let alertController = UIAlertController(title: result.ios?.title, message: result.ios?.message, preferredStyle: .alert)
//            let ok = UIAlertAlet ok = UIAlertAction(title: first, style: .default, handler: firstAction)ction(title: "확인", style: .default) { res -> Void in
//                self.showMain()
//            }
//            let ok2 = UIAlertAction(title: "오늘하루안보기", style: .default) { res -> Void in
//                userPreferences.setValue(Date(), forKey: "notice")
//                self.showMain()
//            }
//            alertController.addAction(ok)
//            alertController.addAction(ok2)
//            self.present(alertController, animated: true, completion: nil)
        } else {
            self.showMain()
        }
    }
    
    func networkFailed(code: Any) {
        failAutoLogin(code)
    }
    
    func networkFailed() {
        failAutoLogin(nil)
    }
    
    func showMain(){
        if userPreferences.bool(forKey: "auto_login") == true && userPreferences.object(forKey: "dtoken") != nil {
            loginModel.autologin()
        } else {
            let main_storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let main = main_storyboard.instantiateViewController(withIdentifier: "firststartvc") as? FirstStartVC else {return}
            self.present(main, animated: false, completion: nil)
        }
    }
    
    func failAutoLogin(_ code: Any?){
        Utility.removeAllUserDefaults()
        
        if code == nil {
            self.view.makeToast(String.login_failed)
        } else {
            if let str = code as? String {
                if str == "no_barcode" {
                    self.view.makeToast(String.no_barcode)
                }
                
                if str == "no_code" {
                    self.view.makeToast(String.no_code)
                }
                
                if str == "no_stuinfo" {
                    self.view.makeToast(String.no_stuinfo)
                }
                
                if str == "notice" {
                    self.showMain()
                }
                
                if str == "version" {
                    let alert = CustomAlert.okAlert(positive: "재시도", title: "오류", message: String.fail_version, positiveAction: { action in
                        let model = LoginModel(self)
                        model.version()
                    })
                    self.present(alert, animated: true, completion: nil)
//                    let alertController = UIAlertController(title: "오류", message: , preferredStyle: .alert)
//                    let ok = UIAlertAction(title: "재시도", style: .default) { res -> Void in
//
//                    }
//                    alertController.addAction(ok)
//                    self.present(alertController, animated: true, completion: nil)
                    
                    
                }
            }
        }
        
        let main_storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let main = main_storyboard.instantiateViewController(withIdentifier: "firststartvc") as? FirstStartVC else {return}
        self.present(main, animated: true, completion: nil)
    }
}
