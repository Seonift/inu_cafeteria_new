//
//  ExtVC.swift
//  class_pick
//
//  Created by SeonIl Kim on 2017. 7. 11..
//  Copyright © 2017년 SeonIl Kim. All rights reserved.
//

import UIKit
import Toast_Swift
import KYDrawerController
import Alamofire

let MAIN = UIStoryboard(name: "Main", bundle: nil)
let SPLASH = UIStoryboard(name: "Splash", bundle: nil)
let INFO = UIStoryboard(name: "Info", bundle: nil)

extension UIViewController: UITextFieldDelegate {
    func addToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.cftBrightSkyBlue
        let doneButton = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(donePressed))
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceBtn, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    @objc func donePressed() {
        view.endEditing(true)
    }
    @objc func cancelPressed() {
        view.endEditing(true) // or do something
    }
}

extension UIViewController {

//    func infoC(_ sender: Any) {
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        guard let infovc = sb.instantiateViewController(withIdentifier: "infovc") as? InfoVC else {return}
//        self.present(infovc, animated: true, completion: nil)
//    }
    
    func setTitleView() {
        let logoIV = UIImageView(image: UIImage(named: "nav_logo"))
        logoIV.contentMode = .scaleAspectFit
        logoIV.frame = CGRect(x: 0, y: 0, width: 130, height: 21.5)
        self.navigationItem.titleView = logoIV
    }
    
    func showHome(_ code: [CafeCode], _ no_student: Bool = false) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let homenav = sb.instantiateViewController(withIdentifier: "homevcnav") as? DefaultNC, let hvc = homenav.viewControllers[0] as? HomeVC, let drawer = sb.instantiateViewController(withIdentifier: "drawervc") as? DrawerVC else { return }
        
        let drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: CGFloat.drawer_width)
        drawerController.mainViewController = homenav
        drawerController.drawerViewController = drawer
        
        if no_student {
            drawer.nonClient()
            hvc.setData(codes: code, nonClient: true)
            userPreferences.removeAllUserDefaults()
        } else {
            hvc.setData(codes: code)
        }
        
        self.present(drawerController, animated: true, completion: nil)
    }
    
    func setupDrawerBtn() {
        let hamburger = UIImage(named: "ic_drawer")
        let hamB = UIButton(frame: CGRect(x: 0, y: 0, width: 21, height: 15))
        hamB.setImage(hamburger, for: .normal)
        hamB.contentMode = .scaleAspectFit
        hamB.addTarget(self, action: #selector(showDrawer(_:)), for: .touchUpInside)
        let lB = UIBarButtonItem(customView: hamB)
        self.navigationItem.leftBarButtonItem = lB
    }
    
    @objc func showDrawer(_ sender: UIButton) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
}
extension UIViewController {
    
    func goLogin() {
        // 로그아웃 했을 경우 로그인 페이지로 귀환
        if (self.presentingViewController?.isKind(of: LoginVC.self))! {
            self.dismiss(animated: true, completion: nil)
        } else {
            guard let loginvc = MAIN.instantiateViewController(withIdentifier: "loginvc") as? LoginVC else {return}
            loginvc.setLoginPage()
            UIApplication.shared.keyWindow?.rootViewController = loginvc
        }
    }
    
//    func networkResult(resultData: Any, code: String) {
//        print(code)
//
//    }
//
//    func networkFailed(code: Any) {
//
//    }
//
//    func networkFailed() {
//        Indicator.stopAnimating()
//        Toast(text: "서버에 접속할 수 없습니다.").show()
//    }
}
