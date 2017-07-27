//
//  HomeVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 18..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import Toaster
import KYDrawerController

import Firebase
import FirebaseInstanceID
import FirebaseMessaging

import NVActivityIndicatorView

class HomeVC: UIViewController, NVActivityIndicatorViewable, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var carouselView: iCarousel!
    @IBOutlet weak var leftB: UIButton!
    @IBOutlet weak var rightB: UIButton!
    
    @IBOutlet weak var topL: UILabel!
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var numberTF: UITextField!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    let names:[String] = ["제1학생식당", "미유", "카페드림 학생식당", "카페드림 도서관", "소담국밥", "김밥천국", "봉구스밥버거"]
    
    var numberHint:UILabel!
    
    override func viewDidLoad() {
        
        self.titleL.text = names[0]
        
        let logoIV = UIImageView(image: UIImage(named: "nav_logo"))
        logoIV.contentMode = .scaleAspectFit
        logoIV.frame = CGRect(x: 0, y: 0, width: 130, height: 21.5)
        self.navigationItem.titleView = logoIV
        
        carouselView.type = .rotary
        carouselView.bounds = carouselView.frame.insetBy(dx: 15, dy: 10)
        carouselView.isPagingEnabled = true
        
        leftB.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
        rightB.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
        confirmBtn.addTarget(self, action: #selector(confirmClicked(_:)), for: .touchUpInside)
        
        topL.font = UIFont(name: "KoPubDotumPM", size: 12)
        titleL.font = UIFont(name: "KoPubDotumPB", size: 20)
        
        setupTF()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        setupDrawerBtn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userPreferences.object(forKey: "socket") != nil {
            showNumberVC(userPreferences.integer(forKey: "code"), userPreferences.integer(forKey: "number"))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        numberTF.text = ""
        numberTF.endEditing(true)
    }
    
    func setupTF(){
        numberTF.font = UIFont(name: "KoPubDotumPB", size: 24)
        numberTF.textColor = UIColor(r: 98, g: 150, b: 174)
        numberTF.backgroundColor = UIColor(rgb: 236)
        numberTF.layer.cornerRadius = 10
        numberTF.clipsToBounds = true
        numberTF.textAlignment = .center
        numberTF.delegate = self
        numberTF.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        numberTF.keyboardType = .numberPad
        numberTF.addDoneButtonOnKeyboard()
//        numberTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        numberTF.setHint(hint: "주문번호를 입력해주세요.", font: UIFont(name: "KoPubDotumPM", size: 12)!, textcolor: UIColor.untGreyishBrown)
        
        numberHint = UILabel(frame: numberTF.bounds)
        numberTF.addSubview(numberHint)
//        label.backgroundColor = .black
        numberHint.text = "주문번호를 입력해주세요."
        numberHint.textAlignment = .center
        numberHint.textColor = UIColor.untGreyishBrown
        numberHint.font = UIFont(name: "KoPubDotumPM", size: 12)
    }
    
    func btnClicked(_ sender: UIButton){
        var index = carouselView.currentItemIndex
        if sender == self.leftB {
            index += 1
        } else if sender == self.rightB {
            index -= 1
        }
        carouselView.scrollToItem(at: index, animated: true)
    }
    
    func confirmClicked(_ sender: UIButton){
        let number = Int(numberTF.text!)
        if self.numberTF.text == nil || self.numberTF.text?.characters.count == 0 {
            Toast(text: "번호를 입력해주세요.").show()
        } else {
            Indicator.startAnimating(activityData)
            
//            print(token)
            let model = NumberModel(self)
            model.registerNumber(code: 1, num1: number!, num2: nil, num3: nil)
//            model.postNum(num: number!, token: token)
        }
    }
    
    //resignFirsReponder
    func handleTap_mainview(_ sender: UITapGestureRecognizer?) {
        print("tap")
        self.numberTF.resignFirstResponder()
        
    }
    
    //TapGesu
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.numberTF))! || (touch.view?.isDescendant(of: self.confirmBtn))! {
            return false
        }
        return true
    }
}

extension HomeVC {
    override func networkResult(resultData: Any, code: String) {
        if code == "register_num" {
            showNumberVC(1, gino(Int(gsno(numberTF.text))))
        }
        
        if code == "logout" {
            logout_ncb()
        }
    }
    
    override func networkFailed(code: Any) {
        Toast.init(text: Strings.noServer()).show()
        Indicator.stopAnimating()
    }
    
    func showNumberVC(_ code:Int, _ number: Int){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        //            guard let vc = sb.instantiateViewController(withIdentifier: "mynumbervc") as? MyNumberVC else { return }
        guard let vc = sb.instantiateViewController(withIdentifier: "mynumbervcnav") as? DefaultNC else { return }
        let mynum = vc.childViewControllers[0] as! MyNumberVC
        
        let drawerC = KYDrawerController(drawerDirection: .left, drawerWidth: CGFloats.drawer_width())
        drawerC.mainViewController = vc
        
        guard let drawer = sb.instantiateViewController(withIdentifier: "drawervc") as? DrawerVC else { return }
        drawerC.drawerViewController = drawer
        drawer.delegate = mynum
        
        mynum.bTitle = gsno(titleL.text)
        mynum.number = number
        mynum.code = code
        
        self.present(drawerC, animated: false, completion: nil)
    }
}

extension HomeVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        numberHint.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" || textField.text?.characters.count == 0 {
            numberHint.isHidden = false
        }
    }
//    func textFieldDidChange(_ textField: UITextField){
//        if textField.text != "" || textField.text?.characters.count != 0 {
//            numberHint.isHidden = true
//        } else {
//            numberHint.isHidden = false
//        }
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}

extension HomeVC: iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
//        return 10
        return names.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "home_default")
        
        return view
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
//            print(value)
            return value * 1.6
        }
        
        //보일 아이템 갯수
        if (option == .count) {
            return 3
        }
        
        //뒤 아이템들 투명화
        if (option == .fadeMin){
            return 0
        }
        if option == .fadeMax {
            return 0
        }
        if option == .fadeRange {
            return 2
        }
        
        return value
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        self.view.endEditing(true)
        self.titleL.text = names[carousel.currentItemIndex]
    }
}

//extension HomeVC: ViewCallback {
//    
//}
