//
//  FirstStartVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 17..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import KYDrawerController
import Toast_Swift
import Device

class FirstStartVC: UIViewController, UIGestureRecognizerDelegate {
    
    // 첫 시작 가이드, 로그인 VC
    
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    
    @IBOutlet weak var labelV: UIView!
    
    @IBOutlet weak var moveBtn: UIView!
    
//    @IBOutlet weak var logo_width: NSLayoutConstraint!
//    @IBOutlet weak var logo_height: NSLayoutConstraint!
//    @IBOutlet weak var logo_leading: NSLayoutConstraint!
    
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
    var showLogin:Bool = false
    
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
    
    lazy var loginModel:LoginModel = {
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
    
    let bgArr:[UIImage?] = [UIImage(named: "bg1"), UIImage(named: "bg2")]
    var index = 0
    let animationDuration:TimeInterval = 1
    let switchingInterval:TimeInterval = 3
    
    lazy var tap:UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(moveLogin(_:)))
        tap.delegate = self
        return tap
    }()
    lazy var mainTap:UITapGestureRecognizer = {
        let mainTap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        mainTap.delegate = self
        return mainTap
    }()
    lazy var checkTap:UITapGestureRecognizer = {
        let checkTap = UITapGestureRecognizer(target: self, action: #selector(cBoxClicked(_:)))
        checkTap.delegate = self
        return checkTap
    }()
    
    var noStudent:Bool = false // true면 비회원로그인
    
    override func viewDidLoad() {
        
        setupUI()
        
        //분기
//        setupFirstStart()
//        setupLogin()
        
//        userPreferences.removeObject(forKey: "not_first")
        
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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.idTF.text = ""
        self.pwTF.text = ""
        autoB.isSelected = false
    }
    
    func setupUI(){
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
        
        let attributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font : UIFont(name: "KoPubDotumPB", size: 15)!,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
            ]
        let string = NSAttributedString(string: "비회원 로그인", attributes: attributes)
        noStudentBtn.setAttributedTitle(string, for: .normal)
    }
    
    func setupLogin(){
        setupLogin1()
        setupLogin2()
        setupLogin3()
    }
    
    func setupLogin1(){
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
    
    func setupLogin2(){
        self.idTF.alpha = 1
        self.pwTF.alpha = 1
        self.autoV.alpha = 1
        self.loginBtn.alpha = 1
        self.noStudentBtn.alpha = 1
        self.noStudentLabel.alpha = 1
    }
    
    func setupLogin3(){
        self.view.addGestureRecognizer(mainTap)
        self.autoV.isUserInteractionEnabled = true
        self.autoV.addGestureRecognizer(checkTap)
    }
    
    @objc func cBoxClicked(_ sender:UITapGestureRecognizer?){
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
//    func zoomImage(){
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
    
    func animateImage(){
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
            UIView.animate(withDuration: 0.5, animations: {
                self.setupLogin2()
            }, completion: { (finished: Bool) in
                self.setupLogin3()
            })
            
        })
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillHide, object: nil)
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

extension FirstStartVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension FirstStartVC:NetworkCallback {
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
        
//        if code == "stuinfo" {
//            let result = resultData as! StudentInfo
//            userPreferences.setValue(result.sno, forKey: "sno")
//            userPreferences.setValue(result.major, forKey: "major")
//            userPreferences.setValue(result.name, forKey: "name")
//            
//            let model = NumberModel(self)
//            model.getCode()
//        }
        
//        if code == "getcode" {
//            let result = resultData as! NSDictionary
//            self.showHome(result)
//        }
    }
    
    func networkFailed(errorMsg: String, code: String) {
        Indicator.stopAnimating()
        self.view.makeToast(errorMsg)
        
//        if code == loginModel._login {
//
//        }
//
//        if code == loginModel._cafecode {
//
//        }
    }
    
//    func networkFailed(code: Any) {
//        Indicator.stopAnimating()
//
//        if code
//
//        if let int = code as? Int {
//            print(int)
//            if int == 400 {
//                self.view.makeToast(String.checkId)
//            } else if int == 404 {
//                self.view.makeToast(String.noServer)
//            }
//        }
//
//        if let str = code as? String {
//            if str == "no_barcode" {
//                self.view.makeToast(.no_barcode)
//            }
//
//            if str == "no_code" {
//                self.view.makeToast(.no_code)
//            }
//
//            if str == "no_stuinfo" {
//                self.view.makeToast(.no_stuinfo)
//            }
//        }
//    }
    
    func networkFailed() {
        self.view.makeToast(.noServer)
    }
}

class LoginTF:UITextField {
    
    override func awakeFromNib() {
        setBorder()
        
        self.font = UIFont(name: "KoPubDotumPM", size: 16)
        self.textColor = UIColor.white
        let attributes:[NSAttributedStringKey:Any] = [.foregroundColor: UIColor.white, .font: UIFont(name: "KoPubDotumPM", size: 16)!]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributes)
        
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        self.leftViewMode = .always
        self.rightViewMode = .always
    }
    
    func setBorder(){
        let border = CALayer()
        let height:CGFloat = 2.0
        let width = Device.getWidth(width: 200)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 5, y: self.frame.size.height - height, width: width, height: self.frame.size.height)
        border.borderWidth = height
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

class CheckBox:UIButton {
    
    override func awakeFromNib() {
        
        let selected = UIImage(named: "login_cbox")
        let unselected = UIImage(named: "login_cbox_no")
        self.setImage(selected, for: .selected)
        self.setImage(unselected, for: .normal)
    }
}
