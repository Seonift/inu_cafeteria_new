//
//  LoginVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 17..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import KYDrawerController
import Toast_Swift
import Device

class LoginVC: UIViewController, UIGestureRecognizerDelegate {
    
    // 첫 시작 가이드, 로그인 VC
    
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    
    @IBOutlet weak var labelV: UIView!
    
    @IBOutlet weak var moveBtn: UIView!
    
    @IBOutlet weak var logo_width2: NSLayoutConstraint!
    @IBOutlet weak var logo_height2: NSLayoutConstraint!
    @IBOutlet weak var logo_leading2: NSLayoutConstraint!
    
    @IBOutlet weak var logo_top: NSLayoutConstraint!
    @IBOutlet weak var logoIV: UIImageView!
    
    @IBOutlet weak var bgIV: UIImageView!
    
    @IBOutlet weak var idTF: LoginTF!
    @IBOutlet weak var pwTF: LoginTF!
    
    @IBOutlet weak var autoB: CheckBox!
    @IBOutlet weak var autoL: UILabel!
    @IBOutlet weak var autoV: UIView!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var noStudentLabel: UILabel!
    @IBOutlet weak var noStudentBtn: UIButton!
    private var showLogin: Bool = false // true면 바로 로그인화면 보여줌
    
    @IBAction func noStudentClicked(_ sender: Any) {
        self.noStudent = true
        loginModel.cafecode()
    }
    
    @IBOutlet weak var idTF_top: NSLayoutConstraint!
    @IBOutlet weak var pwTF_top: NSLayoutConstraint!
    @IBOutlet weak var auto_top: NSLayoutConstraint!
    @IBOutlet weak var loginB_top: NSLayoutConstraint!
    @IBOutlet weak var nsB_top: NSLayoutConstraint!
    @IBOutlet weak var nsL_top: NSLayoutConstraint!
    
    private lazy var loginModel: LoginModel = {
        let model = LoginModel(self)
        return model
    }()
    
    @IBAction func loginClicked(_ sender: Any) {
        if let sno = idTF.text, let pw = pwTF.text {
            if sno == "" || pw == "" {
                self.view.makeToast(String.checkId)
                return
            }
            loginModel.login(sno: sno, pw: pw, auto: autoB.isSelected)
        }
    }
    
    private let bgArr: [UIImage?] = [UIImage(named: "bg1"), UIImage(named: "bg2")]
    private var index = 0
    private let animationDuration: TimeInterval = 1
    private let switchingInterval: TimeInterval = 3
    
    private lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(moveLogin(_:)))
        tap.delegate = self
        return tap
    }()
    private lazy var mainTap: UITapGestureRecognizer = {
        let mainTap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        mainTap.delegate = self
        return mainTap
    }()
    private lazy var checkTap: UITapGestureRecognizer = {
        let checkTap = UITapGestureRecognizer(target: self, action: #selector(cBoxClicked(_:)))
        checkTap.delegate = self
        return checkTap
    }()
    
    private var noStudent: Bool = false // true면 비회원로그인
    
    override func viewDidLoad() {
        setupUI()
        if !userPreferences.isFirstStart() {
            setupLogin()
        }
        animateImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
        
        self.noStudent = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.idTF.text = ""
        self.pwTF.text = ""
        autoB.isSelected = false
    }
    
    func setLoginPage() {
        self.showLogin = true
    }
    
    func setupUI() {
        l1.font = UIFont(name: "KoPubDotumPB", size: 28)
        l2.font = UIFont(name: "KoPubDotumPB", size: 28)
        l3.font = UIFont(name: "KoPubDotumPB", size: 20)
        autoL.font = UIFont(name: "KoPubDotumPM", size: 12)
        idTF.font = UIFont(name: "KoPubDotumPM", size: 16)
        pwTF.font = UIFont(name: "KoPubDotumPM", size: 16)
        pwTF.isSecureTextEntry = true
        idTF.delegate = self
        pwTF.delegate = self
        
        addToolBar(textField: idTF)
        addToolBar(textField: pwTF)
        
        moveBtn.isUserInteractionEnabled = true
        moveBtn.addGestureRecognizer(tap)
        
        autoB.isUserInteractionEnabled = false
        
        noStudentLabel.font = UIFont(name: "KoPubDotumPM", size: 12)
        
        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "KoPubDotumPB", size: 15)!,
            NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue
            ]
        let string = NSAttributedString(string: "비회원 로그인", attributes: attributes)
        noStudentBtn.setAttributedTitle(string, for: .normal)
    }
    
    func setupLogin() {
        setupLogin1()
        setupLogin2()
        setupLogin3()
    }
    
    func setupLogin1() {
        self.view.removeConstraint(logo_leading2)
        self.view.ac_center(item: logoIV, toItem: self.view, origin: "x")
        logo_top = logo_top.setMultiplier(multiplier: 144/333.5)
        logo_width2 = logo_width2.setMultiplier(multiplier: 220/375)
        logo_height2 = logo_height2.setMultiplier(multiplier: 143.6/667)
        
        labelV.isHidden = true
        l3.isHidden = true
        moveBtn.isHidden = true
        
        self.idTF.isHidden = false
        self.pwTF.isHidden = false
        self.autoV.isHidden = false
        self.loginBtn.isHidden = false
        self.noStudentBtn.isHidden = false
        self.noStudentLabel.isHidden = false
        
        self.idTF.alpha = 0
        self.pwTF.alpha = 0
        self.autoV.alpha = 0
        self.loginBtn.alpha = 0
        self.noStudentBtn.alpha = 0
        self.noStudentLabel.alpha = 0
    }
    
    func setupLogin2() {
        self.idTF.alpha = 1
        self.pwTF.alpha = 1
        self.autoV.alpha = 1
        self.loginBtn.alpha = 1
        self.noStudentBtn.alpha = 1
        self.noStudentLabel.alpha = 1
    }
    
    func setupLogin3() {
        self.view.addGestureRecognizer(mainTap)
        self.autoV.isUserInteractionEnabled = true
        self.autoV.addGestureRecognizer(checkTap)
    }
    
    @objc func cBoxClicked(_ sender: UITapGestureRecognizer?) {
        if self.autoB.isSelected == false {
            self.autoB.isSelected = true
        } else {
            self.autoB.isSelected = false
        }
        
        self.view.endEditing(true)
    }
    
    //resignFirsReponder
    @objc func handleTap_mainview(_ sender: UITapGestureRecognizer?) {
        print("tap")
        self.idTF.resignFirstResponder()
        self.pwTF.resignFirstResponder()
        
    }
    
    //TapGesu
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: idTF))! || (touch.view?.isDescendant(of: pwTF))! {
            return false
        }
        return true
    }
      
//    let zoom_duration:TimeInterval = 3.0
//    let fade_duration:TimeInterval = 4.0
//    let full_duration:TimeInterval = 7.0
//    
//    func zoomImage() {
//        CATransaction.begin()
//        
//        CATransaction.setAnimationDuration(full_duration)
//        CATransaction.setCompletionBlock {
//            DispatchQueue.main.async {
//                self.zoomImage()
//            }
//            
//            
//        }
//        
////        print(index)
//        self.bgIV.layer.setAffineTransform(CGAffineTransform(scaleX: 1.0, y: 1.0))
//        UIView.animate(withDuration: zoom_duration, animations: { () -> Void in
//            self.bgIV.layer.setAffineTransform(CGAffineTransform(scaleX: 1.1, y: 1.1))
//        }, completion: {(_ finished: Bool) -> Void in
//            
//            
////            UIView.animate(withDuration: full_duration, animations: { () -> Void in
////                //이미지 전환 시간이 무시됨. 수정해야함
////                
////            })
//            
//
//        })
//        
////        UIView.transition(with: self.bgIV,
////                          duration:self.fade_duration,
////                          options: .transitionCrossDissolve,
////                          animations: { self.bgIV.image = self.bgArr[self.index] },
////                          completion: nil)
//        
//        
//        self.index = self.index < self.bgArr.count - 1 ? self.index + 1 : 0
//        self.bgIV.image = self.bgArr[self.index]
//        CATransaction.commit()
//        
////        DispatchQueue.main.asyncAfter(deadline: .now()+self.zoom_duration) {
////            let transition = CATransition()
////            transition.type = kCATransitionFade
////            self.bgIV.layer.add(transition, forKey: kCATransition)
////        }
//        
//        
//        
//        
////        self.bgIV.image = self.bgArr[self.index]
//        
//        
//        
////        self.index = self.index < self.bgArr.count - 1 ? self.index + 1 : 0
//    }
    
    func animateImage() {
//        https://stackoverflow.com/questions/26898955/adding-image-transition-animation-in-swift
        
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setCompletionBlock {
            DispatchQueue.main.asyncAfter(deadline: .now()+self.switchingInterval) {
                self.animateImage()
            }
        }
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        self.bgIV.layer.add(transition, forKey: kCATransition)
        if self.index < self.bgArr.count {
            self.bgIV.image = self.bgArr[self.index]
        }
        
        CATransaction.commit()
        
        self.index = self.index < self.bgArr.count - 1 ? self.index + 1 : 0
    }
    
    @objc func moveLogin(_ sender: UITapGestureRecognizer?) {
        print("movelogin")
        self.moveBtn.removeGestureRecognizer(tap)
        
        setupLogin1()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            if finished {
                UIView.animate(withDuration: 0.5, animations: {
                    self.setupLogin2()
                }, completion: { (finished: Bool) in
                    if finished {
                        self.setupLogin3()
                    }
                })
            }
        })
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            if keyboardSize.height == 0.0 {
                return
            }
            logo_top = logo_top.setMultiplier(multiplier: 1/333.5)
            UIView.animate(withDuration: duration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(note: NSNotification) {
        if let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            logo_top = logo_top.setMultiplier(multiplier: 144/333.5)
            UIView.animate(withDuration: duration, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
    }
}

extension LoginVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension LoginVC: NetworkCallback {
    func networkResult(resultData: Any, code: String) {
        Indicator.stopAnimating()
        print(code)
        
        if code == loginModel._login {
            
            if let result = resultData as? LoginObject {
                if let token = result.token {
                    userPreferences.saveToken(token: token)
                }
                if let barcode = result.barcode {
                    userPreferences.saveBarcode(barcode: barcode)
                    loginModel.cafecode()
                }
            }
        }
        
        if code == loginModel._cafecode {
            if let result = resultData as? [CafeCode] {
                self.showHome(result, self.noStudent)
            }
        }
    }
    
    func networkFailed(errorMsg: String, code: String) {
        Indicator.stopAnimating()
        self.view.makeToast(errorMsg)
    }
    func networkFailed() {
        self.view.makeToast(.noServer)
    }
}
