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
import Device
import ObjectMapper

import SocketIO

class HomeVC: UIViewController {
    @IBOutlet weak var carouselView: iCarousel!
    @IBOutlet weak var topL: UILabel!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scroll_bottomConst: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var numView1: NumberView!
    @IBOutlet weak var numView2: NumberView!
    @IBOutlet weak var numView3: NumberView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet var dummy1_Const: NSLayoutConstraint!
    @IBOutlet var dummy2_Const: NSLayoutConstraint!
    @IBOutlet var dummy3_Const: NSLayoutConstraint!
    
    private var menus: NSDictionary? // 각 식당 메뉴들
    private var nonClient: Bool = false // true면 비회원모드
    private lazy var numberModel: NumberModel = {
        return NumberModel(self)
    }()
    private lazy var loginModel: LoginModel = {
        return LoginModel(self)
    }()
    private lazy var networkModel: NetworkModel = {
        return NetworkModel(self)
    }()
    private let tf_height: CGFloat = 40.0
    private var activeField: UITextField?
    
    private var num_count: Int = 1 {
        // 입력할 번호의 갯수
        didSet {
            setInputNum()
        }
        willSet(v) {
            if v < 1 { self.num_count = 1 }
            if v > 3 { self.num_count = 3 }
        }
    }
    
    private var codes: [CafeCode] = [] { // 식당 정보
        didSet {
            codes = codes.sorted(by: { $0.order < $1.order })
            if carouselView != nil {
                carouselView.reloadData()
                
                if carouselView.currentItemIndex == 0 && self.codes.count > 0 {
                    self.titleL.text = codes[0].name // 식당 이름 출력
                }
            }
        }
    }
    
    private lazy var moreButton: UIBarButtonItem = {
        let image = UIImage(named: "icMoreHoriz3X")
        let btn = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(moreClicked(_:)))
        return btn
    }()
    
    override func viewDidLoad() {
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTitleView() // 네비바에 카페테리아 로고 출력
        
        registerForKeyboardNotifications()
        
        if self.codes.count > 0 {
            self.titleL.text = codes[carouselView.currentItemIndex].name
        }
        
        if menus == nil {
            networkModel.foodplan()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        numberModel.isNumberWait()
//        SocketIOManager.sharedInstance.removeAll()
        setTitleView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
        [numView1, numView2, numView3].forEach { view in
            view?.clear()
        }
        num_count = 1
        self.navigationItem.titleView = nil
    }
    
    func setData(codes: [CafeCode], nonClient: Bool = false) {
        // 초기 값 설정
        self.codes = codes
        self.nonClient = nonClient
    }
    
    func setInputNum() {
        // 번호 텍스트필드 갯수 조절
        switch num_count {
        case 1:
            dummy1_Const.isActive = true
            dummy2_Const.isActive = false
            dummy3_Const.isActive = false
            self.numView2.isHidden = true
            self.numView3.isHidden = true
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
                [self.numView2, self.numView2.plusBtn, self.numView2.minusBtn].forEach { view in
                    view.isHidden = false
                }
            case 3:
                self.numView3.isHidden = false
                self.numView2.plusBtn.isHidden = true
                self.numView2.minusBtn.isHidden = true
            default:
                print()
            }
        })
    }
    
    func setupUI() {
        carouselView.type = .rotary
        carouselView.bounds = carouselView.frame.insetBy(dx: 15, dy: 10)
        carouselView.isPagingEnabled = true
        
        confirmBtn.addTarget(self, action: #selector(confirmClicked(_:)), for: .touchUpInside)
        confirmBtn.layer.cornerRadius = 22
        confirmBtn.clipsToBounds = true
        confirmBtn.layer.borderColor = UIColor(rgb: 170).cgColor
        confirmBtn.layer.borderWidth = 0.8
        
        setupDrawerBtn()
        
        numView1.commonInit(index: 0, parent: self)
        numView2.commonInit(index: 1, parent: self)
        numView3.commonInit(index: 2, parent: self)
        [numView1.plusBtn, numView2.plusBtn, numView2.minusBtn, numView3.minusBtn].forEach { btn in
            btn.addTarget(self, action: #selector(addClicked(_:)), for: .touchUpInside)
        }
        [numView1.textField, numView2.textField, numView3.textField].forEach { tf in
            addToolBar(textField: tf)
        }
        
        self.navigationItem.rightBarButtonItem = moreButton
        scrollView.contentSize = contentView.frame.size // 스크롤 뷰에서 스크롤 될 아이템의 크기 설정.
    }
    
    @objc func moreClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "문의하기", style: .default, handler: { _ in
            self.loginModel.version()
        }))
        alert.addAction(UIAlertAction(title: "앱 정보", style: .default, handler: { _ in
            guard let vc = INFO.instantiateViewController(withIdentifier: "newinfovc") as? NewInfoVC else { return }
            self.present(vc, animated: true, completion: nil)
        }))
        if !nonClient {
            alert.addAction(UIAlertAction(title: "로그아웃", style: .default, handler: { _ in
                let alertC = CustomAlert.alert(message: String.logout, positiveAction: { _ in
                    self.loginModel.logout()
                })
                self.present(alertC, animated: true, completion: nil)
            }))
        } else {
            alert.addAction(UIAlertAction(title: "나가기", style: .default, handler: { _ in
                userPreferences.removeAllUserDefaults()
                self.dismiss(animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.view.tintColor = UIColor.cftBrightSkyBlue
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addClicked(_ sender: UIButton) {
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
    
    @objc func confirmClicked(_ sender: UIButton) {
        if let item = codes[safe: carouselView.currentItemIndex] {
            // item : 헌재 선택한 식당
            if !item.alarm {
                self.view.makeToast(String.noAlarm)
                return
            }
            
            var nums: [Int] = []
            switch num_count {
            case 3:
                if let num = numView3.number {
                    nums.append(num)
                }
                fallthrough
            case 2:
                if let num = numView2.number {
                    nums.append(num)
                }
                fallthrough
            case 1:
                if let num = numView1.number {
                    nums.append(num)
                } else {
                    self.view.makeToast(String.noNumber)
                    return
                }
            default:
                print()
            }
            nums = nums.reversed()
            numberModel.registerNumber(code: item._no, nums: nums)
        }
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
            scroll_bottomConst.constant = keyboardSize.height
            UIView.animate(withDuration: duration, animations: {
                self.view.layoutIfNeeded()
                if let field = self.activeField {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: field.frame.origin.y)
                }
            }, completion: { _ in
                self.scrollView.contentSize = self.contentView.frame.size
            })
        }
    }
    
    @objc func keyboardWillHide(note: NSNotification) {
        if let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            scroll_bottomConst.constant = 0
            UIView.animate(withDuration: duration, animations: {
                self.scrollView.contentOffset = .zero
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.scrollView.contentSize = self.contentView.frame.size
            })
        }
    }
}

extension HomeVC: NetworkCallback {
    
    func networkResult(resultData: Any, code: String) {
        log.info(code)
        Indicator.stopAnimating()
        
        if code == loginModel._logout {
            goLogin()
        }
        
        if code == numberModel._isNumberWait {
            // 번호 대기 화면으로 이동
            guard let result = resultData as? WaitNumber else { return }
            
            let cafes = codes.filter { $0.no == result.cafecode }
            if let item = cafes.first {
                showNumVC(code: item._no, title: item.name, numbers: result._num, bgimg: item.bgimg)
            }
        }
        
        if code == numberModel._registerNumber {
            numberModel.isNumberWait()
        }
        
        if code == networkModel._foodplan {
            if let result = resultData as? NSDictionary {
                self.menus = result
            }
        }
        
        if code == loginModel._version {
            if let result = resultData as? VerObject {
                guard let csrvc = MAIN.instantiateViewController(withIdentifier: "csrvc") as? CsrVC else { return }
                if let log = result.ios?.log {
                    csrvc.setData(log: log, parent: self)
                }
                self.navigationController?.pushViewController(csrvc, animated: true)
            }
        }
    }
    
    func networkFailed(errorMsg: String, code: String) {
        log.info(code)
        Indicator.stopAnimating()
        
        if code == loginModel._logout {
            self.view.makeToast("다시 시도해주세요.")
        }
        
        if code == numberModel._isNumberWait {
            numberModel.resetNumber()
        }
        
        if code == numberModel._registerNumber {
            self.view.makeToast(errorMsg)
        }
        
        if code == loginModel._version {
            guard let csrvc = MAIN.instantiateViewController(withIdentifier: "csrvc") as? CsrVC else { return }
            csrvc.setData(parent: self)
            self.navigationController?.pushViewController(csrvc, animated: true)
        }
    }
    
    func networkFailed() {
        log.info("")
        Indicator.stopAnimating()
        
        self.view.makeToast(String.noServer)
    }
    
    func showNumVC(code: Int, title: String, numbers: [Int], bgimg: String? = nil) {
        guard let vc = MAIN.instantiateViewController(withIdentifier: "numbervc") as? NumberVC else { return }
        vc.commonInit(code: code, title: title, numbers: numbers, bgimg: bgimg)
        
        vc.navigationItem.setHidesBackButton(true, animated: false)
        vc.setTitleView()
        vc.setupDrawerBtn()
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension HomeVC {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.scrollView.setContentOffset(.zero, animated: true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn: "0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        if string == numberFiltered {
            let currentString: NSString = (textField.text ?? "") as NSString
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
        
        let item = codes[index]
        
        //44 45
        if item.menu != -1 {
            let imageView = UIImageView(image: UIImage(named: "icMenu"))
            imageView.contentMode = .scaleAspectFit
            let _width = Device.getWidth(width: 44)
            let _height = Device.getWidth(width: 45)
            let x = width - _width - Device.getWidth(width: 5)
            let y = width - _height - Device.getWidth(width: 5)
            imageView.frame = CGRect(x: x, y: y, width: _width, height: _height)
            view.addSubview(imageView)
        }
        
        if codes.count > index {
            let imagename = "s\(codes[index].no)"
            
            if let image = UIImage(named: imagename) {
                view.image = image
                return view
            } else {
                if let url = URL(string: "\(BASE_URL + item.img)") {
                    view.kf.setImage(with: url) { (_, error, _, _) in
                        if error != nil {
                            view.image = UIImage(named: "home_default")
                        }
                    }
                }
            }
        }
        return view
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        numView1.textField.resignFirstResponder()
        numView2.textField.resignFirstResponder()
        numView3.textField.resignFirstResponder()
        
        if codes[index].menu != -1 && carousel.currentItemIndex == index {
            guard let vc = MAIN.instantiateViewController(withIdentifier: "menuvc") as? MenuVC else { return }
            vc.modalPresentationStyle = .overCurrentContext
            let code = codes[index]._no
            if let menus = menus {
                print(menus)
                if let json = menus.value(forKey: "\(String(code))") as? NSArray {
                    print(json)
                    if let plan = Mapper<FoodMenu>().mapArray(JSONObject: json) {
                        vc.setData(menu: plan, code: code)
                    }
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            //            print(value)
            return value * 1.6
        }
        
        //보일 아이템 갯수
        if option == .count {
            return 3
        }
        
        //뒤 아이템들 투명화
        if option == .fadeMin {
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
    func setShadow(_ radius: CGFloat = 5, ratio: CGFloat = 1, color: UIColor = UIColor(r: 240, g: 240, b: 240)) {
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
