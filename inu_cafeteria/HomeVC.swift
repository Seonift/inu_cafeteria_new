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
    @IBOutlet weak var num2TF: UITextField!
    @IBOutlet weak var num3TF: UITextField!
    
    @IBOutlet weak var numAddBtn: UIButton!
    @IBOutlet weak var num2_height: NSLayoutConstraint!
    @IBOutlet weak var num3_height: NSLayoutConstraint!
    let tf_height:CGFloat = 40.0
    
    @IBOutlet weak var confirmBtn: UIButton!
    
//    let names:[String] = ["제1학생식당", "미유", "카페드림 학생식당", "카페드림 도서관", "소담국밥", "김밥천국", "봉구스밥버거"]
    
    var numberHint:UILabel!
    
    var num_count:Int = 1 {
        //입력할 번호의 갯수
        didSet {
            if num_count == 2 {
                num2_height.constant = tf_height
            } else if num_count == 3 {
                num3_height.constant = tf_height
            }
            UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func numAddClicked(_ sender: Any) {
        if num_count < 3 {
            num_count += 1
        }
    }
    
    var code:NSDictionary = [:] {
        didSet {
            names = code.allKeys as! [String]
            codes = code.allValues as! [String]
            if titleL != nil {
                if names.count > 0 {
                    self.titleL.text = names[0]
                }
            }
            if carouselView != nil {
                carouselView.reloadData()
            }
        }
    }
    
    var names:[String] = []
    var codes:[String] = []
    
    override func viewDidLoad() {
        
//        print("token:\(FIRInstanceID.instanceID().token()))")
        
        
        
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
//        if userPreferences.object(forKey: "socket") != nil {
//            let arr = [userPreferences.integer(forKey: "num1"), userPreferences.integer(forKey: "num2"), userPreferences.integer(forKey: "num3")]
//            showNumberVC(userPreferences.integer(forKey: "code"), arr)
//        }
        
        Indicator.startAnimating(activityData)
        let model = NumberModel(self)
        model.isNumberWait()
        
//        carouselView.reloadData()
        print(code)
        print(names)
        print(codes)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        numberTF.text = ""
        numberTF.endEditing(true)
        numberHint.isHidden = false
        
        num2TF.text = ""
        num2TF.endEditing(true)
        num3TF.text = ""
        num3TF.endEditing(true)
    }
    
    func setupTF(){
        setupTextField(numberTF)
        setupTextField(num2TF)
        setupTextField(num3TF)
        
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
    
    func setupTextField(_ sender:UITextField){
        sender.font = UIFont(name: "KoPubDotumPB", size: 24)
        sender.textColor = UIColor(r: 98, g: 150, b: 174)
        sender.backgroundColor = UIColor(rgb: 236)
        sender.layer.cornerRadius = 10
        sender.clipsToBounds = true
        sender.textAlignment = .center
        sender.delegate = self
        sender.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        sender.keyboardType = .numberPad
        sender.addDoneButtonOnKeyboard()
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
        if self.numberTF.text == nil || self.numberTF.text?.characters.count == 0 {
            Toast(text: "번호를 입력해주세요.").show()
        } else {
            Indicator.startAnimating(activityData)
            
//            print(token)
            
            let code:Int = Int(codes[carouselView.currentItemIndex])!
            let number = Int(numberTF.text!)!
            let model = NumberModel(self)
            
            switch self.num_count {
            case 1:
                model.registerNumber(code: code, num1: number, num2: nil, num3: nil)
            case 2:
                let num2 = Int(num2TF.text!)!
                model.registerNumber(code: code, num1: number, num2: num2, num3: nil)
            case 3:
                let num2 = Int(num2TF.text!)!
                let num3 = Int(num3TF.text!)!
                model.registerNumber(code: code, num1: number, num2: num2, num3: num3)
            default:
                print()
            }
            
            
            
            
            
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
        if (touch.view?.isDescendant(of: self.numberTF))! || (touch.view?.isDescendant(of: self.confirmBtn))! || (touch.view?.isDescendant(of: self.num2TF))! || (touch.view?.isDescendant(of: self.num3TF))! || (touch.view?.isDescendant(of: self.numAddBtn))!{
            return false
        }
        return true
    }
    
    func findKeyForValue(value: String, dictionary: NSDictionary) -> Any?
    {
        
        for item in dictionary {
            if item.value as! String == value {
                return item.key
            }
        }
        
        return nil
    }
    
    func getNameFromCode(code: Int) -> String {
        let name = findKeyForValue(value: String(code), dictionary: self.code) as! String
        return name
    }
    
}

extension HomeVC {
    override func networkResult(resultData: Any, code: String) {
        if code == "register_num" {
            let index = self.carouselView.currentItemIndex
            let value = codes[index] //  코드값
            let code_value = Int(value)
            let name = getNameFromCode(code: code_value!)
            
            var arr:[Int] = []
//            [gino(Int(gsno(numberTF.text))), -1, -1]
            
            switch self.num_count {
            case 3:
                arr.append(Int(gsno(num3TF.text))!)
                fallthrough
            case 2:
                arr.append(Int(gsno(num2TF.text))!)
                fallthrough
            case 1:
                arr.append(Int(gsno(numberTF.text))!)
            default:
                print("")
            }
            arr.reverse()
            print(arr)
            
            showNumberVC(name, code_value!, arr)
        }
        
        if code == "logout" {
            logout_ncb()
        }
        
        if code == "isnumberwait" {
            let json = resultData as! NSDictionary
            
//            let arr = [userPreferences.integer(forKey: "num1"), userPreferences.integer(forKey: "num2"), userPreferences.integer(forKey: "num3")]
//            showNumberVC(userPreferences.integer(forKey: "code"), arr)

            var arr:[Int] = []
            
            if json.count == 0 || json.count == 1 {
                Indicator.stopAnimating()
                return
            }
            
            let code = json["code"] as! String
            let num1 = Int(json["num1"] as! String)
            let num2 = Int(json["num2"] as! String)
            let num3 = Int(json["num3"] as! String)
//            arr = [num1!, num2!, num3!]
            
            if num2 == -1 || num2 == nil {
                arr.append(num1!)
            } else if num3 == -1 || num3 == nil {
                arr.append(num2!)
            } else {
                arr.append(num3!)
            }
            
//            arr.reverse()
            print(arr)
            Indicator.stopAnimating()
            
            let name = getNameFromCode(code: Int(code)!)
            showNumberVC(name, Int(code)!, arr)

        }
    }
    
    override func networkFailed(code: Any) {
        if let str = code as? String {
            if str == "isnumberwait" {
                //번호 못받아올 경우 대처.
            }
        }
        
        if let num = code as? Int {
            if num == 400 {
                Toast(text: Strings.noServer()).show()
            }
        }
        
        Indicator.stopAnimating()
    }
    
    override func networkFailed() {
        Toast.init(text: Strings.noServer()).show()
        Indicator.stopAnimating()
    }
    
    func showNumberVC(_ name:String, _ code:Int, _ numbers: [Int]){
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
        mynum.numbers = numbers
        mynum.name = name
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
//        return names.count
        return code.count
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
//        self.titleL.text = names[carousel.currentItemIndex]
//        if let name = names[carousel.currentItemIndex] as? String {
//            self.titleL.text = name
//        }
        
        if names.count > carousel.currentItemIndex {
            self.titleL.text = names[carousel.currentItemIndex]
        }
    }
}

//extension HomeVC: ViewCallback {
//    
//}
