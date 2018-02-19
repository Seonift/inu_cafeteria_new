//
//  HomeVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 18..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import Toast_Swift
import KYDrawerController
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import NVActivityIndicatorView
import Device

class HomeVC: UIViewController, NVActivityIndicatorViewable, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var carouselView: iCarousel!
    
    @IBOutlet weak var topL: UILabel!
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let tf_height:CGFloat = 40.0
    
    @IBOutlet weak var numView1: NumberView!
    @IBOutlet weak var numView2: NumberView!
    @IBOutlet weak var numView3: NumberView!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var dummy1_Const: NSLayoutConstraint!
    @IBOutlet weak var dummy2_Const: NSLayoutConstraint!
    @IBOutlet weak var dummy3_Const: NSLayoutConstraint!
    
//    let names:[String] = ["제1학생식당", "미유", "카페드림 학생식당", "카페드림 도서관", "소담국밥", "김밥천국", "봉구스밥버거"]
    
//    var no_student:Bool = false
    
    lazy var numberModel:NumberModel = {
        return NumberModel(self)
    }()
    
    lazy var loginModel:LoginModel = {
        return LoginModel(self)
    }()
    
    var nonClient:Bool = false // true면 비회원모드
    
    var num_count:Int = 1 {
        // 입력할 번호의 갯수
        didSet {
            switch num_count {
            case 1:
                dummy1_Const.isActive = true
                dummy2_Const.isActive = false
                dummy3_Const.isActive = false
                self.numView2.isHidden = true
            case 2:
                dummy1_Const.isActive = false
                dummy2_Const.isActive = true
                dummy3_Const.isActive = false
                self.numView3.isHidden = true
            case 3:
                dummy1_Const.isActive = false
                dummy2_Const.isActive = false
                dummy3_Const.isActive = true
            default:
                print()
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                switch self.num_count {
                case 1:
                    self.numView1.plusBtn.isHidden = false
                case 2:
                    self.numView1.plusBtn.isHidden = true
                    self.numView2.isHidden = false
                    self.numView2.plusBtn.isHidden = false
                    self.numView2.minusBtn.isHidden = false
                case 3:
                    self.numView3.isHidden = false
                    self.numView2.plusBtn.isHidden = true
                    self.numView2.minusBtn.isHidden = true
                default:
                    print()
                }
            })
        }
        willSet(v){
            if v < 1 { self.num_count = 1 }
            if v > 3 { self.num_count = 3 }
        }
    }
    
//    @IBAction func numAddClicked(_ sender: Any) {
//        if num_count < 3 {
//            num_count += 1
//        }
//    }
//
//    @IBAction func numMinusClicked(_ sender: Any) {
//        if num_count > 1 {
//            num_count -= 1
//        }
//    }
    
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
    
    lazy var moreButton:UIBarButtonItem = {
        let image = UIImage(named: "icMoreHoriz3X")
        let btn = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(moreClicked(_:)))
        return btn
    }()
    
    override func viewDidLoad() {
        setupUI()
    }
    
    func setupUI(){
        setTitleView()
        
        carouselView.type = .rotary
        carouselView.bounds = carouselView.frame.insetBy(dx: 15, dy: 10)
        carouselView.isPagingEnabled = true
        
        confirmBtn.addTarget(self, action: #selector(confirmClicked(_:)), for: .touchUpInside)
        confirmBtn.layer.cornerRadius = 22
        confirmBtn.clipsToBounds = true
        confirmBtn.layer.borderColor = UIColor(rgb: 170).cgColor
        confirmBtn.layer.borderWidth = 0.8
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        setupDrawerBtn()
        
//        if no_student == true {
//            setupLeftBtn()
//        }
        
        numView1.commonInit(index: 0, parent: self)
        numView2.commonInit(index: 1, parent: self)
        numView3.commonInit(index: 2, parent: self)
        numView1.plusBtn.addTarget(self, action: #selector(addClicked(_:)), for: .touchUpInside)
        numView2.plusBtn.addTarget(self, action: #selector(addClicked(_:)), for: .touchUpInside)
        numView2.minusBtn.addTarget(self, action: #selector(addClicked(_:)), for: .touchUpInside)
        numView3.minusBtn.addTarget(self, action: #selector(addClicked(_:)), for: .touchUpInside)
        
        
        self.navigationItem.rightBarButtonItem = moreButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        numberModel.isNumberWait()
        
        SocketIOManager.sharedInstance.removeAll()
        
        setTitleView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        numView1.clear()
        numView2.clear()
        numView3.clear()
        
        num_count = 1
        
        unregisterForKeyboardNotifications()
        
        self.navigationItem.titleView = nil
//        print("homevc willdisappear")
        userPreferences.setValue(UIScreen.main.brightness, forKey: "brightness")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        print("homevc diddisappear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
        
        if self.codes.count > 0 {
            self.titleL.text = codes[carouselView.currentItemIndex].name
        }
        
//        if no_student == true {
//            setupLeftBtn()
//        }
    }
    
//    func setupLeftBtn(){
//        //왼쪽에 드로워 대신 뒤로가기 버튼
//        let backBtn = UIButton(type: .custom)
//        backBtn.setImage(UIImage(named: "btnBack"), for: .normal)
//        backBtn.frame = CGRect(x: 0, y: 0, width: 18, height: 18)r
//        backBtn.addTarget(self, action: #selector(finish), for: .touchUpInside)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
//    }
    
//    @objc func finish(){
//        self.dismiss(animated: true, completion: nil)
//    }
    
    @objc func moreClicked(_ sender: UIBarButtonItem){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "문의하기", style: .default, handler: { action in
            guard let csrvc = MAIN.instantiateViewController(withIdentifier: "csrvc") as? CsrVC else { return }
            self.navigationController?.pushViewController(csrvc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "앱 정보", style: .default, handler: { action in
            guard let vc = MAIN.instantiateViewController(withIdentifier: "infovc") as? InfoVC else { return }
            self.present(vc, animated: true, completion: nil)
        }))
        if !nonClient {
            alert.addAction(UIAlertAction(title: "로그아웃", style: .default, handler: { action in
                let alertC = CustomAlert.alert(message: String.logout, positiveAction: { action in
                    self.loginModel.logout()
                })
                self.present(alertC, animated: true, completion: nil)
            }))
        } else {
            alert.addAction(UIAlertAction(title: "나가기", style: .default, handler: { action in
                Utility.removeAllUserDefaults()
                self.dismiss(animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.view.tintColor = UIColor.cftBrightSkyBlue
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addClicked(_ sender: UIButton){
        if sender == numView1.plusBtn {
            self.num_count = 2
        }
        if sender == numView2.plusBtn {
            self.num_count = 3
        }
        if sender == numView2.minusBtn {
            self.num_count = 1
        }
        if sender == numView3.minusBtn {
            self.num_count = 2
        }
    }
    
    @objc func confirmClicked(_ sender: UIButton){
        
//        if self.numberTF.text == nil || self.numberTF.text?.count == 0 {
//            self.view.makeToast("번호를 입력해주세요.")
//        } else {
//            self.view.endEditing(true)
//
//            Indicator.startAnimating(activityData)
//
//            let code = Int(codes[carouselView.currentItemIndex].code!)!
//            let number = Int(numberTF.text!)!
////            let model = NumberModel(self)
//
//            var num2 = -1
//            var num3 = -1
//
//            switch self.num_count {
//            case 3:
//                if num3TF.text != nil && num3TF.text?.count != 0 {
//                    num3 = Int(num3TF.text!)!
//                }
//                fallthrough
//            case 2:
//                if num2TF.text != nil && num2TF.text?.count != 0 {
//                    num2 = Int(num2TF.text!)!
//                }
//                break
//            default:
//                print()
//            }
//
//            numberModel.registerNumber(code: code, num1: number, num2: num2, num3: num3)
//        }
    }
    
    //resignFirsReponder
    @objc func handleTap_mainview(_ sender: UITapGestureRecognizer?) {
//        print("tap")
        self.numView1.textField.resignFirstResponder()
        self.numView2.textField.resignFirstResponder()
        self.numView3.textField.resignFirstResponder()
        self.scrollView.setContentOffset(.zero, animated: true)
    }
    
    //TapGesu
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: numView1))! || (touch.view?.isDescendant(of: numView2))! || (touch.view?.isDescendant(of: numView3))! || (touch.view?.isDescendant(of: confirmBtn))! {
            return false
        }
        return true
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
            
            self.scrollView.isScrollEnabled = true
            
            UIView.animate(withDuration: duration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(note: NSNotification) {
        if let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
//            self.tableView_bottomConst.constant = 0
            self.scrollView.isScrollEnabled = false
            UIView.animate(withDuration: duration, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
    }
}

extension HomeVC: NetworkCallback {
    func networkResult(resultData: Any, code: String) {
        if code == "register_num" {
//            let index = self.carouselView.currentItemIndex
            
            numberModel.isNumberWait()
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
    
    func networkFailed(code: Any) {
        print("networkfailed")
        if let str = code as? String {
            print(str)
            if str == "isnumberwait" {
                //번호 못받아올 경우 대처.
                numberModel.resetNumber()
            }
        }
        
        if let num = code as? Int {
            if num == 400 {
                self.view.makeToast(String.noServer)
            }   
        }
        
        Indicator.stopAnimating()
    }
    
    func networkFailed() {
        self.view.makeToast(String.noServer)
        Indicator.stopAnimating()
    }
    
    func showNumberVC(_ name:String, _ code:Int, _ numbers: [Int]){
        guard let vc = MAIN.instantiateViewController(withIdentifier: "mynumbervcnav") as? DefaultNC else { return }
        let mynum = vc.childViewControllers[0] as! MyNumberVC
        
        mynum.bTitle = gsno(titleL.text)
        mynum.numbers = numbers
        mynum.name = name
        mynum.code = code
        
        
        if userPreferences.object(forKey: "no_student") != nil {
            self.present(vc, animated: false, completion: nil)
        } else {
            let drawerC = KYDrawerController(drawerDirection: .left, drawerWidth: CGFloat.drawer_width)
            drawerC.mainViewController = vc
            
            guard let drawer = MAIN.instantiateViewController(withIdentifier: "drawervc") as? DrawerVC else { return }
            drawerC.drawerViewController = drawer
//            drawer.delegate = mynum
            
            self.present(drawerC, animated: false, completion: nil)
        }
    }
}

extension HomeVC: UITextFieldDelegate {
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        numberHint.isHidden = true
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.text == "" || textField.text?.count == 0 {
//            numberHint.isHidden = false
//        }
//    }

//    func textFieldDidChange(_ textField: UITextField){
//        if textField.text != "" || textField.text?.characters.count != 0 {
//            numberHint.isHidden = true
//        } else {
//            numberHint.isHidden = false
//        }
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.scrollView.setContentOffset(.zero, animated: true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        if string == numberFiltered {
            let currentString:NSString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return newString.count <= 4
        }
        
        return false
        
//        return string == numberFiltered
    }
}

extension HomeVC: iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return codes.count
    }

    func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
        return Device.getWidth(width: 150)
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let width = Device.getWidth(width: 150)
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .white
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
        
        //44 45
        if true {
            let imageView = UIImageView(image: UIImage(named: "icMenu"))
            imageView.contentMode = .scaleAspectFit
            let _width = Device.getWidth(width: 44)
            let _height = Device.getWidth(width: 45)
            let x = width - _width - Device.getWidth(width: 5)
            let y = width - _height - Device.getWidth(width: 5)
            imageView.frame = CGRect(x: x, y: y, width: _width, height: _height)
//            imageView.setShadow(_width / 2, color: .gray)
            view.addSubview(imageView)
        }
        
        if codes.count > index {
            let imagename = "s"+gsno(codes[index].code)
            guard let image = UIImage(named: imagename) else {
                view.image = UIImage(named: "home_default")
                return view
            }
            view.image = image
            return view
        }
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

extension UIView {
    func setShadow(_ radius: CGFloat = 5, ratio: CGFloat = 1, color: UIColor = UIColor(r: 240, g: 240, b: 240)){
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius
        self.layer.shadowOffset = CGSize(width: 1 * ratio, height: 0)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
    }
}
//extension HomeVC: ViewCallback {
//    func passData(resultData: Any, code: String) {
//        print(code)
//        
//        if code == "csr" {
//            showCsr()
//        }
//        
//        if code == "info" {
//            showInfo()
//        }
//        
//        if code == "logout" {
//            logOut(self)
//        }
//    }
//}



