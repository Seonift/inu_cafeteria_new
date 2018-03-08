////
////  LoginVC.swift
////  inu_cafeteria
////
////  Created by SeonIl Kim on 2017. 7. 18..
////  Copyright © 2017년 appcenter. All rights reserved.
////
//
//import UIKit
//import KYDrawerController
//
//class LoginVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
//    @IBOutlet weak var loginBtn: UIButton!
//    @IBOutlet weak var idTF: LoginTF!
//    @IBOutlet weak var pwTF: LoginTF!
//    
//    @IBOutlet weak var autoV: UIView!
//    @IBOutlet weak var autoL: UILabel!
//    @IBOutlet weak var autoCbox: CheckBox!
//    
//    
//    
//    override func viewDidLoad() {
//        
////        Utility.showFont()
//        
////        autoL.font = UIFont(name: "KoPubDotumPM", size: 12)
////        
////        
////        idTF.delegate = self
////        pwTF.delegate = self
////        
////        autoCbox.isUserInteractionEnabled = false
//        
////        idTF.backgroundColor = .black
////        pwTF.backgroundColor = .black
//        
////        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
////        tap.delegate = self
////        self.view.addGestureRecognizer(tap)
////        
////        let checktap = UITapGestureRecognizer(target: self, action: #selector(cBoxClicked(_:)))
//////        autoV.isUserInteractionEnabled = true
////        autoV.addGestureRecognizer(checktap)
//
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
////        idTF.text = ""
////        pwTF.text = ""
////        autoCbox.isSelected = false
//    }
//    
//    @IBAction func loginClicked(_ sender: Any) {
//        
//       
//    }
//    
//    func cBoxClicked(_ sender: UITapGestureRecognizer?) {
//        
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
////        self.view.endEditing(true)
////        return false
//    }
//    
//    //resignFirsReponder
//    func handleTap_mainview(_ sender: UITapGestureRecognizer?) {
//        print("tap")
//        self.idTF.resignFirstResponder()
//        self.pwTF.resignFirstResponder()
//        
//    }
//    
//    //TapGesu
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if (touch.view?.isDescendant(of: idTF))! || (touch.view?.isDescendant(of: pwTF))! || (touch.view?.isDescendant(of: autoCbox))! {
//            return false
//        }
//        return true
//    }
//}
//
//
