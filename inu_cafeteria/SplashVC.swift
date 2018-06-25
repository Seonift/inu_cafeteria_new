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
    
    // 작동하는 명령
    // 1. 앱 버전 체크
    // 2. 공지사항 확인
    // 3. 로그인 화면 출력
    // 4. 자동 로그인(토큰 확인 완료)
    // 5. 식당 코드 불러오고 홈 화면 호출
    
    private var delayInSeconds = 2.0 //요청까지 딜레이 시간
    
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
                self.loginModel.version() // 1. 앱 버전 체크
            } else {
                let alert = CustomAlert.okAlert(positive: "재시도", title: "오류", message: "인터넷 연결을 확인해주세요.", positiveAction: { _ in
                    self.loginModel.version() // 1. 앱 버전 체크
                })
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension SplashVC: NetworkCallback {
    
    func networkResult(resultData: Any, code: String) {
        log.info(code)
        Indicator.stopAnimating() // 인디케이터 없애기
        
        if code == loginModel._version {
            // 1. 앱 버전 체크
            if let result = resultData as? VerObject,
                let latest = result.ios?.latest, let current = Bundle.main.versionNumber {
                if latest.compare(current, options: .numeric) == .orderedDescending {
                   // 업데이트 필요
                    showUpdateAlert()
                } else {
                    // 최신 버전
                    self.loginModel.notice() // 2. 공지사항 확인
                }
            }
        }
        
        if code == loginModel._notice {
             // 2. 공지사항 확인
            guard let result = resultData as? NoticeObject else { return }
            showNoticeAlert(notice: result)
        }
        
        if code == loginModel._login {
            // 4. 자동 로그인(토큰 확인 완료)
            loginModel.cafecode()
        }
        
        if code == loginModel._logout {
            self.showLogin()
        }
        
        if code == loginModel._cafecode {
            // 5. 식당 코드 불러오고 홈 화면 호출
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
            loginModel.logout()
        }
    }
    
    func networkFailed() {
        log.info("")
        Indicator.stopAnimating()
        self.view.makeToast(String.noServer)
    }
}

extension SplashVC {
    
    func showLogin() {
        // 3. 로그인 화면 출력
        if userPreferences.isToken() {
            // 자동로그인 된 유저
            loginModel.login()
        } else {
            // 자동로그인이 안됐거나 최초 진입
            let main_storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let main = main_storyboard.instantiateViewController(withIdentifier: "loginvc") as? LoginVC else {return}
            self.present(main, animated: false, completion: nil)
        }
    }
    
    // Alert 출력
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
                self.showLogin() // 3. 로그인 화면 출력
            }, secondAction: { _ in
                // 다시 보지 않기
                userPreferences.setAllNoticeId(id: id) // userdefault에 최근 수신한 전체 공지 id 저장
                self.showLogin() // 3. 로그인 화면 출력
            })
            self.present(alert, animated: true, completion: nil)
        } else if let id = ios.isVaild(), userPreferences.iOSNoticeCheck(id: id) {
            let alert = CustomAlert.noticeAlert(title: ios.title, message: ios.message, firstAction: { _ in
                self.showLogin()
            }, secondAction: { _ in
                // 다시 보지 않기
                userPreferences.setiOSNoticeId(id: id) // userdefault에 최근 수신한 전체 공지 id 저장
                self.showLogin() // 3. 로그인 화면 출력
            })
            self.present(alert, animated: true, completion: nil)
        } else {
            self.showLogin() // 3. 로그인 화면 출력
        }
    }
}
