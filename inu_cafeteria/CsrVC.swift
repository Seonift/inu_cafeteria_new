//
//  CsrVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 8. 19..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import Toast_Swift

class CsrVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var tf_width: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
//        let logoIV = UIImageView(image: UIImage(named: "nav_logo"))
//        logoIV.contentMode = .scaleAspectFit
//        logoIV.frame = CGRect(x: 0, y: 0, width: 130, height: 21.5)
//        self.navigationItem.titleView = logoIV
        
        
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(r: 189, g: 189, b: 183).cgColor
        textField.textColor = UIColor.untGreyishBrown
        textField.font = UIFont(name: "KoPubDotumPL", size: 15)
//        textField.setHint(hint: "문의하실 내용을 적어주세요.", font: UIFont(name: "KoPubDotumPL", size: 15)!, textcolor: UIColor(r: 189, g: 189, b: 183))
        textField.layer.cornerRadius = 5.0
        textField.textAlignment = .center
        textField.delegate = self
        
        sendBtn.addTarget(self, action: #selector(sendClicked(_:)), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        if DeviceUtil.smallerThanSE() == true {
            tf_width.constant = tf_width.constant * 0.75
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setTitleView()
    }
    
    @objc func sendClicked(_ sender: UIButton) {
        if textField.text == nil || textField.text == "" {
            self.view.makeToast(String.noContents)
        } else {
            self.textField.endEditing(true)
            let model = CsrModel(self)
            model.errormsg(msg: gsno(textField.text))
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.sendClicked(self.sendBtn)
        self.sendBtn.sendActions(for: .touchUpInside)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(r: 144, g: 186, b: 203).cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(r: 189, g: 189, b: 183).cgColor
    }
    
    //resignFirsReponder
    @objc func handleTap_mainview(_ sender: UITapGestureRecognizer?) {
        print("tap")
        self.textField.resignFirstResponder()
    }
    
    //TapGesu
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.textField))! || (touch.view?.isDescendant(of: self.sendBtn))!{
            return false
        }
        return true
    }
}

extension CsrVC:NetworkCallback {
    func networkResult(resultData: Any, code: String) {
        if code == "errormsg" {
            self.view.makeToast(String.csrSuc)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func networkFailed(code: Any) {
        
    }
    
    func networkFailed() {
        self.view.makeToast(String.noServer)
    }
}
