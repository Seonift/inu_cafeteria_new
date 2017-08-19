//
//  CsrVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 8. 19..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import Toaster

class CsrVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    
    override func viewDidLoad() {
        
        let logoIV = UIImageView(image: UIImage(named: "nav_logo"))
        logoIV.contentMode = .scaleAspectFit
        logoIV.frame = CGRect(x: 0, y: 0, width: 130, height: 21.5)
        self.navigationItem.titleView = logoIV
        
        
        titleL.font = UIFont(name: "KoPubDotumPB", size: 20)
        
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(r: 189, g: 189, b: 183).cgColor
        textField.textColor = UIColor.untGreyishBrown
        textField.font = UIFont(name: "KoPubDotumPL", size: 15)
        textField.setHint(hint: "문의하실 내용을 적어주세요.", font: UIFont(name: "KoPubDotumPL", size: 15)!, textcolor: UIColor(r: 189, g: 189, b: 183))
        textField.layer.cornerRadius = 5.0
        textField.textAlignment = .center
        textField.delegate = self
        
        sendBtn.addTarget(self, action: #selector(sendClicked(_:)), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    func sendClicked(_ sender: UIButton) {
        if textField.text == nil || textField.text == "" {
            Toast(text: "문의내용이 입력되지 않았습니다").show()
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
    func handleTap_mainview(_ sender: UITapGestureRecognizer?) {
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

extension CsrVC {
    override func networkResult(resultData: Any, code: String) {
        if code == "errormsg" {
            Toast(text: "문의사항이 접수되었습니다").show()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func networkFailed() {
        Toast(text: Strings.noServer()).show()
    }
}
