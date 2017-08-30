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
    
    @IBOutlet weak var numMinusBtn: UIButton!
    @IBOutlet weak var numAddBtn: UIButton!
    @IBOutlet weak var num2_height: NSLayoutConstraint!
    @IBOutlet weak var num3_height: NSLayoutConstraint!
    let tf_height:CGFloat = 40.0
    
    @IBOutlet weak var numAddBtn2: UIButton!
    @IBOutlet weak var numMinusBtn2: UIButton!
    @IBOutlet weak var numMinusBtn3: UIButton!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var carousel_height_const: NSLayoutConstraint!
    let carousel_height:CGFloat = 170.0
    
//    let names:[String] = ["제1학생식당", "미유", "카페드림 학생식당", "카페드림 도서관", "소담국밥", "김밥천국", "봉구스밥버거"]
    
    var numberHint:UILabel!
    
    var no_student:Bool = false {
        didSet {
            if no_student == true {
                setupLeftBtn()
            }
        }
    }
    
    var num_count:Int = 1 {
        //입력할 번호의 갯수
        didSet {
            if DeviceUtil.smallerThanSE() == false {
                print("num_count:\(num_count)")
                if num_count == 2 {
                    num2_height.constant = tf_height
                    num3_height.constant = 0
                } else if num_count == 3 {
                    num3_height.constant = tf_height
                } else if num_count == 1 {
                    num2_height.constant = 0
                    num3_height.constant = 0
                }
                UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
                    self.view.layoutIfNeeded()
                    
                    switch self.num_count {
                    case 1:
                        self.numAddBtn.isHidden = false
                        //                    self.numMinusBtn.isHidden = false
                        
                        self.numAddBtn2.isHidden = true
                        self.numMinusBtn2.isHidden = true
                        
                        //                    self.numAddBtn3.isHidden = true
                        self.numMinusBtn3.isHidden = true
                        
                    case 2:
                        self.numAddBtn2.isHidden = false
                        self.numMinusBtn2.isHidden = false
                        
                        self.numAddBtn.isHidden = true
                        //                    self.numMinusBtn.isHidden = true
                        
                        //                    self.numAddBtn3.isHidden = true
                        self.numMinusBtn3.isHidden = true
                        
                    case 3:
                        //                    self.numAddBtn3.isHidden = false
                        self.numMinusBtn3.isHidden = false
                        
                        self.numAddBtn2.isHidden = true
                        self.numMinusBtn2.isHidden = true
                    default:
                        print("")
                    }
                })
            }
        }
    }
    
    @IBAction func numAddClicked(_ sender: Any) {
        if num_count < 3 {
            num_count += 1
        }
    }
    
    @IBAction func numMinusClicked(_ sender: Any) {
        if num_count > 1 {
            num_count -= 1
        }
    }
    
//    var code:NSDictionary = [:] {
//        didSet {
//            names = code.allKeys as! [String]
//            codes = code.allValues as! [String]
//            if titleL != nil {
//                if names.count > 0 {
//                    self.titleL.text = names[0]
//                }
//            }
//            if carouselView != nil {
//                carouselView.reloadData()
//            }
//        }
//    }
    
    var codes:[CodeObject] = [] {
        didSet {
            if carouselView != nil {
                carouselView.reloadData()
                
                if carouselView.currentItemIndex == 0 && self.codes.count > 0 {
                    self.titleL.text = codes[0].name
                }
            }
        }
    }
    
//    var names:[String] = []
//    var codes:[String] = []
    
    override func viewDidLoad() {
        
//        let model = LoginModel(self)
//        model.stuinfo()
        
//        print("token:\(FIRInstanceID.instanceID().token()))")
        
        
        setTitleView()
        
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
        
        if DeviceUtil.smallerThanSE() == true {
            self.numAddBtn.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if userPreferences.object(forKey: "socket") != nil {
//            let arr = [userPreferences.integer(forKey: "num1"), userPreferences.integer(forKey: "num2"), userPreferences.integer(forKey: "num3")]
//            showNumberVC(userPreferences.integer(forKey: "code"), arr)
//        }
        
//        Indicator.startAnimating(activityData)
        
        
        let model = NumberModel(self)
        model.isNumberWait()
        
        SocketIOManager.sharedInstance.removeAll()
        
        setTitleView()
        
//        carouselView.reloadData()
//        print(code)
//        print(names)
//        print(codes)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        numberTF.text = ""
        numberTF.endEditing(true)
        numberHint.isHidden = false
        
        num2TF.text = ""
        num2TF.endEditing(true)
        num3TF.text = ""
        num3TF.endEditing(true)
        
        num_count = 1
        
        unregisterForKeyboardNotifications()
        
        self.navigationItem.titleView = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
        
        if self.codes.count > 0 {
            self.titleL.text = codes[carouselView.currentItemIndex].name
        }
        
        if no_student == true {
            setupLeftBtn()
//            self.navigationItem.leftBarButtonItem = nil
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "정보", style: .plain, target: self, action: #selector(infoC(_:)))
        }
        
//        setTitleView()
    }
    
    func setupLeftBtn(){
        //왼쪽에 드로워 대신 뒤로가기 버튼
        
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "btnBack"), for: .normal)
        backBtn.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        backBtn.addTarget(self, action: #selector(finish), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
    }
    
    func finish(){
        self.dismiss(animated: true, completion: nil)
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
        numberHint.text = "대기번호를 입력해주세요."
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
            index -= 1
        } else if sender == self.rightB {
            index += 1
        }
        carouselView.scrollToItem(at: index, animated: true)
    }
    
    func confirmClicked(_ sender: UIButton){
        if self.numberTF.text == nil || self.numberTF.text?.characters.count == 0 {
            Toast(text: "번호를 입력해주세요.").show()
        } else {
            self.view.endEditing(true)
            
            Indicator.startAnimating(activityData)
            
            let code = Int(codes[carouselView.currentItemIndex].code!)!
            let number = Int(numberTF.text!)!
            let model = NumberModel(self)
            
            var num2 = -1
            var num3 = -1
            
            switch self.num_count {
            case 3:
                if num3TF.text != nil && num3TF.text?.characters.count != 0 {
                    num3 = Int(num3TF.text!)!
                }
                fallthrough
            case 2:
                if num2TF.text != nil && num2TF.text?.characters.count != 0 {
                    num2 = Int(num2TF.text!)!
                }
                break
            default:
                print()
            }
            
            model.registerNumber(code: code, num1: number, num2: num2, num3: num3)
        }
    }
    
    //resignFirsReponder
    func handleTap_mainview(_ sender: UITapGestureRecognizer?) {
        print("tap")
        self.numberTF.resignFirstResponder()
        self.num2TF.resignFirstResponder()
        self.num3TF.resignFirstResponder()
    }
    
    //TapGesu
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.numberTF))! || (touch.view?.isDescendant(of: self.confirmBtn))! || (touch.view?.isDescendant(of: self.num2TF))! || (touch.view?.isDescendant(of: self.num3TF))! || (touch.view?.isDescendant(of: self.numAddBtn))!{
            return false
        }
        return true
    }
    
    func adjustKeyboardHeight(_ show:Bool, _ notification:NSNotification){
        
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            var userInfo = notification.userInfo!
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
            let changeInHeight = ( keyboardFrame.height ) * (show ? 1 : -1)
            // let defaul_logo_bottom_constant = self.logo_bottom.constant
            
            if show {
                self.carousel_height_const.constant = 0
            } else {
                self.carousel_height_const.constant = carousel_height
            }
            
            
            UIView.animate(withDuration: animationDuration, animations: {(_) -> Void
                
                in
                
                if show {
                    self.topL.isHidden = true
//                    self.leftB.isHidden = true
//                    self.rightB.isHidden = true
                    self.carouselView.isHidden = true
                } else {
                    self.topL.isHidden = false
//                    self.leftB.isHidden = false
//                    self.rightB.isHidden = false
                    self.carouselView.isHidden = false
                }
                
                self.view.layoutIfNeeded()
            })
            
        }//if let keyboardSize
        
    }
    
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(note: NSNotification) {
        adjustKeyboardHeight(true, note)
    }
    
    func keyboardWillHide(note: NSNotification) {
        adjustKeyboardHeight(false, note)
    }
    
}

extension HomeVC {
    override func networkResult(resultData: Any, code: String) {
        if code == "register_num" {
//            let index = self.carouselView.currentItemIndex
            
            let model = NumberModel(self)
            model.isNumberWait()
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
            
            if num1 != -1 && num1 != nil {
                print("append num1")
                arr.append(num1!)
            }
            if num2 != -1 && num2 != nil {
                print("append num2")
                arr.append(num2!)
            }
            if num3 != -1 && num3 != nil {
                print("append num3")
                arr.append(num3!)
            }
            
            
//            arr.reverse()
            print(arr)
            Indicator.stopAnimating()
            
//            let name = getNameFromCode(code: Int(code)!)
            let name = "테스트"
            showNumberVC(name, Int(code)!, arr)

        }
    }
    
    override func networkFailed(code: Any) {
        print("networkfailed")
        if let str = code as? String {
            print(str)
            if str == "isnumberwait" {
                //번호 못받아올 경우 대처.
                let model = NumberModel(self)
                model.resetNumber()
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
        
        mynum.bTitle = gsno(titleL.text)
        mynum.numbers = numbers
        mynum.name = name
        mynum.code = code
        
        if userPreferences.object(forKey: "no_student") != nil {
            self.present(vc, animated: false, completion: nil)
        } else {
            let drawerC = KYDrawerController(drawerDirection: .left, drawerWidth: CGFloats.drawer_width())
            drawerC.mainViewController = vc
            
            guard let drawer = sb.instantiateViewController(withIdentifier: "drawervc") as? DrawerVC else { return }
            drawerC.drawerViewController = drawer
            drawer.delegate = mynum
            
            self.present(drawerC, animated: false, completion: nil)
        }
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
        return codes.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        view.contentMode = .scaleAspectFit
        
        view.backgroundColor = .white
//        view.layer.cornerRadius = 5.0
//        view.layer.masksToBounds = true
        
        if codes.count > index {
            let imagename = "s"+gsno(codes[index].code)
            guard let image = UIImage(named: imagename) else {
                view.image = UIImage(named: "home_default")
                return view
            }
            view.image = image
            return view
            
//            let url = URL(string: gsno(codes[index].img))
//            view.kf.setImage(with: url, placeholder: UIImage(named: "home_default"), options: nil, progressBlock: nil, completionHandler: nil)
        }

//        view.layer.borderColor = UIColor.gray.cgColor
//        view.layer.borderWidth = 1.0
        view.image = UIImage(named: "home_default")
        
        return view
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        print(gsno(codes[index].img))
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
        
        if codes.count > carousel.currentItemIndex {
            self.titleL.text = codes[carousel.currentItemIndex].name
        }
    }
}



