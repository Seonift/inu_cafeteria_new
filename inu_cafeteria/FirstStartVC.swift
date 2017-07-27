//
//  FirstStartVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 17..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import KYDrawerController
import Toaster

class FirstStartVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    
    @IBOutlet weak var labelV: UIView!
    
    @IBOutlet weak var moveBtn: UIView!
    
    @IBOutlet weak var logo_width: NSLayoutConstraint!
    @IBOutlet weak var logo_height: NSLayoutConstraint!
    @IBOutlet weak var logo_leading: NSLayoutConstraint!
    @IBOutlet weak var logo_top: NSLayoutConstraint!
    @IBOutlet weak var logoIV: UIImageView!
    
    @IBOutlet weak var bgIV: UIImageView!
    
    @IBOutlet weak var idTF: LoginTF!
    @IBOutlet weak var pwTF: LoginTF!
    
    @IBOutlet weak var autoB: CheckBox!
    @IBOutlet weak var autoL: UILabel!
    @IBOutlet weak var autoV: UIView!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    var showLogin:Bool = false
    
    @IBAction func loginClicked(_ sender: Any) {
        
        Indicator.startAnimating(activityData)
        let model = LoginModel(self)
        var auto:Bool!
        if autoB.isSelected {
            auto = true
        } else {
            auto = false
        }
        model.login(idTF.text!, pwTF.text!, auto)
        print("id:\(idTF.text!), pw:\(pwTF.text!)")
    }
    
    let bgArr:[UIImage] = [UIImage(named: "bg1")!, UIImage(named: "bg2")!, UIImage(named: "bg3")!]
    var index = 0
    let animationDuration:TimeInterval = 1
    let switchingInterval:TimeInterval = 3
    
    var tap:UITapGestureRecognizer!
    var mainTap:UITapGestureRecognizer!
    var checkTap:UITapGestureRecognizer!
    
    override func viewDidLoad() {
        
        setupUI()
        
        //분기
//        setupFirstStart()
//        setupLogin()
        
//        userPreferences.removeObject(forKey: "not_first")
        
        if userPreferences.bool(forKey: "not_first") == true {
            setupLogin()
        } else {
            userPreferences.set(true, forKey: "not_first")
        }
        
        
        idTF.text = "201101720"
        pwTF.text = "@"
        animateImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
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
        
        moveBtn.isUserInteractionEnabled = true
        tap = UITapGestureRecognizer(target: self, action: #selector(moveLogin(_:)))
        tap.delegate = self
        moveBtn.addGestureRecognizer(tap)
        
        autoB.isUserInteractionEnabled = false
    }
    
    func setupFirstStart(){
        
        
    }
    
    func setupLogin(){
        setupLogin1()
        setupLogin2()
        setupLogin3()
    }
    
    func setupLogin1(){
        self.logo_width.constant = 220.0
        self.logo_height.constant = 71.4
        self.view.removeConstraint(logo_leading)
        self.view.ac_center(item: logoIV, toItem: self.view, origin: "x")
        self.logo_top.constant = 143.6
        
//        l1.isHidden = true
//        l2.isHidden = true
        labelV.isHidden = true
        l3.isHidden = true
        moveBtn.isHidden = true
        
        self.idTF.isHidden = false
        self.pwTF.isHidden = false
        self.autoV.isHidden = false
        self.loginBtn.isHidden = false
        
        self.idTF.alpha = 0
        self.pwTF.alpha = 0
        self.autoV.alpha = 0
        self.loginBtn.alpha = 0
    }
    
    func setupLogin2(){
        self.idTF.alpha = 1
        self.pwTF.alpha = 1
        self.autoV.alpha = 1
        self.loginBtn.alpha = 1
    }
    
    func setupLogin3(){
        mainTap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        mainTap.delegate = self
        self.view.addGestureRecognizer(mainTap)
        
        checkTap = UITapGestureRecognizer(target: self, action: #selector(cBoxClicked(_:)))
        checkTap.delegate = self
        self.autoV.isUserInteractionEnabled = true
        self.autoV.addGestureRecognizer(checkTap)
    }
    
    func cBoxClicked(_ sender:UITapGestureRecognizer?){
        if self.autoB.isSelected == false {
            self.autoB.isSelected = true
        } else {
            self.autoB.isSelected = false
        }
        
        self.view.endEditing(true)
    }
    
    //resignFirsReponder
    func handleTap_mainview(_ sender: UITapGestureRecognizer?) {
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
        self.bgIV.image = self.bgArr[self.index]
        
        CATransaction.commit()
        
        self.index = self.index < self.bgArr.count - 1 ? self.index + 1 : 0
    }
    
    func moveLogin(_ sender: UITapGestureRecognizer?) {
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
}

extension FirstStartVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension FirstStartVC {
    override func networkResult(resultData: Any, code: String) {
        Indicator.stopAnimating()
        print(code)
        if code == "login" {
            let result = resultData as! Bool
            if result == true {
                print(result)
                self.showHome()
            }
        }
    }
    
    override func networkFailed(code: Any) {
        Indicator.stopAnimating()
        let c = code as! Int
        if c == 400 {
            Toast.init(text: "학번/비밀번호를 확인해주세요.").show()
        }
    }
}

class LoginTF:UITextField {
    
    override func awakeFromNib() {
        setBorder()
        
        self.font = UIFont(name: "KoPubDotumPM", size: 16)
        self.textColor = UIColor.white
        let attributes:[String:Any] = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "KoPubDotumPM", size: 16)!]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributes)
        
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        self.leftViewMode = .always
        self.rightViewMode = .always
    }
    
    func setBorder(){
        let border = CALayer()
        let width:CGFloat = 2.0
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 5, y: self.frame.size.height - width, width: self.frame.size.width-10, height: self.frame.size.height)
        border.borderWidth = width
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
