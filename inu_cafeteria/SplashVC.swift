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

class SplashVC: UIViewController {
    
    private var delayInSeconds = 2.0
    
    private lazy var loginModel: LoginModel = {
        let model = LoginModel(self)
        return model
    }()
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //서버 접속 불가일 때랑 인터넷 연결 안될경우 예외처리 필요함
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            if Reachability.isConnectedToNetwork() {
                self.loginModel.version()
            } else {
                let alert = CustomAlert.okAlert(positive: "재시도", title: "오류", message: "인터넷 연결을 확인해주세요.", positiveAction: { _ in
                    self.loginModel.version()
                })
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func showLogin() {
        if userPreferences.isToken() {
            loginModel.login()
        } else {
            let main_storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let main = main_storyboard.instantiateViewController(withIdentifier: "firststartvc") as? FirstStartVC else {return}
            self.present(main, animated: false, completion: nil)
        }
    }
}

extension SplashVC: NetworkCallback {
    
    func networkResult(resultData: Any, code: String) {
        log.info(code)
        Indicator.stopAnimating()
        
        if code == loginModel._version {
            if let result = resultData as? VerObject,
                let latest = result.ios?.latest, let current = Bundle.main.versionNumber {
                if latest.compare(current, options: .numeric) == .orderedDescending {
                   // 업데이트 필요
                    showUpdateAlert()
                } else {
                    // 최신 버전
                    self.loginModel.notice()
                }
            }
        }
        
        if code == loginModel._notice {
            guard let result = resultData as? NoticeObject else { return }
            showNoticeAlert(notice: result)
        }
        
        if code == loginModel._login {
            loginModel.cafecode()
        }
        
        if code == loginModel._logout {
            self.showLogin()
        }
        
        if code == loginModel._cafecode {
            guard let result = resultData as? [CafeCode] else {return}
            showHome(result, false)
        }
    }
    
    func networkFailed(errorMsg: String, code: String) {
        log.info(code)
        Indicator.stopAnimating()
        
        if code == loginModel._version {
            let alert = CustomAlert.okAlert(positive: "재시도", title: "오류", message: errorMsg, positiveAction: { _ in
                self.loginModel.version()
            })
            self.present(alert, animated: true, completion: nil)
        }
        
        if code == loginModel._notice {
            self.showLogin()
        }
        
        if code == loginModel._login {
            self.view.makeToast(errorMsg)
            loginModel.logout()
        }
        
        if code == loginModel._logout {
            self.showLogin()
        }
        
        if code == loginModel._cafecode {
            self.view.makeToast(errorMsg)
        }
    }
    
    func networkFailed() {
        log.info("")
        Indicator.stopAnimating()
        self.view.makeToast(String.noServer)
    }
    
    func showUpdateAlert() {
        let alert = CustomAlert.okAlert(title: "업데이트", message: String.update, positiveAction: { _ in
            if let url = URL(string: String.appStore), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(url)
                }
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNoticeAlert(notice: NoticeObject) {
        guard let all = notice.all, let ios = notice.ios else { return }
        if let id = all.isVaild(), userPreferences.allNoticeCheck(id: id) {
            // 전체 공지가 있으면 전체 공지 출력
            let alert = CustomAlert.noticeAlert(title: all.title, message: all.message, firstAction: { _ in
                self.showLogin()
            }, secondAction: { _ in
                // 하루 보지 않기
                userPreferences.setAllNoticeId(id: id)
                self.showLogin()
            })
            self.present(alert, animated: true, completion: nil)
        } else if let id = ios.isVaild(), userPreferences.iOSNoticeCheck(id: id) {
            let alert = CustomAlert.noticeAlert(title: ios.title, message: ios.message, firstAction: { _ in
                self.showLogin()
            }, secondAction: { _ in
                // 하루 보지 않기
                userPreferences.setiOSNoticeId(id: id)
                self.showLogin()
            })
            self.present(alert, animated: true, completion: nil)
        } else {
            self.showLogin()
        }
    }
    
}
