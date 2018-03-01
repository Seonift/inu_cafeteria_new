//
//  DrawerVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 19..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import TextImageButton
import KYDrawerController
import Kingfisher
import FSPagerView
import Device

class DrawerVC: UIViewController, FSPagerViewDelegate, FSPagerViewDataSource {
    @IBOutlet weak var barcodeIV: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var noInternetLabel: UILabel!
    
    @IBOutlet weak var noLoginLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var dotView: DottedLineView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //    @IBOutlet weak var pageControl: FSPageControl!
    
    lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl(frame: .zero)
        pageControl.currentPage = 0
        pageControl.setFillColor(UIColor.cftBrightSkyBlue, for: .selected)
        pageControl.setFillColor(UIColor(rgb: 201), for: .normal)
        pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 6.5, height: 6.5)), for: .normal)
        pageControl.setPath(UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 6.5, height: 6.5)), for: .selected)
        pageControl.interitemSpacing = 4.5
        //        pageControl.backgroundColor = .blue
        return pageControl
    }()
    @IBOutlet weak var adView: FSPagerView! {
        didSet {
            self.adView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: cellId)
        }
    }
    
    var adItems:[AdObject] = []
    
//    var imageURL = ["" ,"", "", "", ""]
    
    lazy var flagModel:FlagModel = {
        let model = FlagModel(self)
        return model
    }()
    
    lazy var networkModel:NetworkModel = {
        let model = NetworkModel(self)
        return model
    }()
    
    private let cellId = "Cell"
    private var _nonClient:Bool = false
    
    override func viewDidLoad() {
        setupUI()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        adView.itemSize = adView.frame.size
        
        flagModel.activeBarcode(1)
        adView.automaticSlidingInterval = 5.0
        if adItems.count == 0 {
            networkModel.ads()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(comebackForeground), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: .UIApplicationDidEnterBackground, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        log.info("viewdidappear")
        userPreferences.saveBrightness()
        UIScreen.main.brightness = CGFloat(1.0)
    }
    
    @objc func comebackForeground(){
        flagModel.activeBarcode(1)
    }
    
    @objc func enterBackground(){
        flagModel.activeBarcode(0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        log.info("viewwilldisappear")
        flagModel.activeBarcode(0)
        adView.automaticSlidingInterval = 0
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        log.info("viewdiddisappear")
        if let bright = userPreferences.getBrightness() {
            UIScreen.main.brightness = bright
        }
    }
    
    func setupUI(){
        adView.isInfinite = true
        adView.scrollDirection = .vertical
        
        infoView.layer.cornerRadius = Device.getWidth(width: 12)
        infoView.layer.borderColor = UIColor(rgb: 170).cgColor
        infoView.layer.borderWidth = 0
        infoView.layer.shadowOpacity = 0.1
        infoView.layer.shadowColor = UIColor(r: 7, g:0, b: 2).cgColor
        infoView.layer.shadowOffset = CGSize(width: 1.5, height: 0)
        infoView.layer.shadowRadius = infoView.layer.cornerRadius
        
        
        if let sno = userPreferences.getSNO() {
            idLabel.text = sno
        } else {
            idLabel.text = ""
        }
        self.view.addSubview(pageControl)
        
        
        //        let x = adView.frame.origin.x + adView.frame.width + Device.getWidth(width: 10)
        //        pageControl.frame = CGRect(x: x, y: 0, width: 6.5, height: adView.frame.height)
        //        pageControl.center.y = adView.center.y
        
        
        let width:CGFloat = 6.5
        let height:CGFloat = Device.getHeight(height: 284.5)
        let x:CGFloat = Device.getWidth(width: 27.5 + 185.5 + 10) - height + width
        let y:CGFloat = Device.getHeight(height: 28 + 45.5 + 287.5)
        pageControl.frame.size = CGSize(width: width, height: height)
        pageControl.transform = CGAffineTransform(rotationAngle: .pi / 2)
        pageControl.frame.origin = CGPoint(x: x, y: y)
        
        //        pageControl.layer.position = CGPoint(x: x, y: y)
        
    }
    
    func setupBarcode(_ value: Bool){
        if value {
            if let barcode = userPreferences.getBarcode() {
                barcodeIV.image = generateBarcode(from: barcode)
            } else {
                barcodeIV.isHidden = true
                if !_nonClient {
                    noInternetLabel.isHidden = false
                }
            }
        } else {
            barcodeIV.isHidden = true
            if !_nonClient {
                noInternetLabel.isHidden = false
            }
        }
    }
    
    func nonClient() {
        // 비회원 모드
        
        _nonClient = true
        
        titleLabel.textColor = UIColor(r:56, g:177, b:228, a:0.6)
        noLoginLabel.isHidden = false
        
        barcodeIV.isHidden = true
        noInternetLabel.isHidden = true
        contentLabel.isHidden = true
        dotView.isHidden = true
        idLabel.isHidden = true
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return adItems.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: cellId, at: index)
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.kf.setImage(with: URL(string: "\(BASE_URL)/\(adItems[index].img)")!)
        cell.contentView.layer.shadowRadius = 0
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int) {
        
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: false)
        
        if let drawer = parent as? KYDrawerController {
            drawer.setDrawerState(.closed, animated: true)
        }
        
        guard let vc = MAIN.instantiateViewController(withIdentifier: "advc") as? AdVC else { return }
        vc.modalPresentationStyle = .overCurrentContext
        vc.adItems = self.adItems
        vc.firstIndex = index
        self.present(vc, animated: true, completion: nil)
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        pageControl.currentPage = index
        print(index)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        pageControl.currentPage = targetIndex
        print(targetIndex)
    }
    
}

extension DrawerVC: NetworkCallback {
    func networkResult(resultData: Any, code: String) {
//        if code == "activebarcode" {
//            if let code = resultData as? Int {
//                if code == 1 { setupBarcode(true) }
//            }
//        }
        
        log.info(code)
        if code == flagModel._activeBarcode {
            if let result = resultData as? Bool, result {
                setupBarcode(true)
            }
        }
        
        if code == networkModel._ads {
            if let result = resultData as? [AdObject] {
                self.adItems = result.filter { $0.title != "" }
            }
            adView.reloadData()
            pageControl.numberOfPages = adItems.count
        }
    }
    
    func networkFailed(errorMsg: String, code: String) {
        log.info(code)
        
        if code == flagModel._activeBarcode {
            setupBarcode(false)
        }
        
//        if code == "activebarcode" {
//            setupBarcode(false)
//        }
    }
    
    func networkFailed() {
        
    }
}

////
////  temp.swift
////  inu_cafeteria
////
////  Created by SeonIl Kim on 2018. 2. 18..
////  Copyright © 2018년 appcenter. All rights reserved.
////
//
//import UIKit
//
//class DrawerVC2: UIViewController {
//
//    @IBOutlet weak var titleL: UILabel!
//
//    var delegate:ViewCallback?
//    @IBOutlet weak var no_internet_label: UILabel!
//
//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var image_const: NSLayoutConstraint!
//
//    @IBOutlet weak var nameL: UILabel!
//    @IBOutlet weak var numL: UILabel!
//
//    @IBOutlet weak var guideL: UILabel!
//
//    var infoB: TextImageButton!
//    var logoutB: TextImageButton!
//    var csrB: TextImageButton!
//
//    @IBOutlet weak var titleL_top: NSLayoutConstraint!
//    //    @IBOutlet weak var nameL_top: NSLayoutConstraint!
//    //    @IBOutlet weak var numL_top: NSLayoutConstraint!
//    @IBOutlet weak var logo_Top: NSLayoutConstraint!
//    @IBOutlet weak var barcode_top_const: NSLayoutConstraint!
//    @IBOutlet weak var guideL_top_const: NSLayoutConstraint!
//
//    @IBOutlet weak var barcode_width: NSLayoutConstraint!
//    @IBOutlet weak var barcode_height: NSLayoutConstraint!
//
//    //    @IBOutlet weak var infoBtn: TextImageButton!
//    //    @IBOutlet weak var logoutBtn: TextImageButton!
//
//    @IBOutlet weak var barcodeBG: UIView!
//    @IBOutlet weak var barcodeIV: UIImageView! {
//        didSet {
//            if barcodeIV.isHidden {
//                no_internet_label.isHidden = false
//                no_internet_label.layer.cornerRadius = 5
//                no_internet_label.clipsToBounds = true
//            }
//        }
//    }
//
//    //    var current_bright:CGFloat = 1.0 {
//    //        didSet {
//    //            print("current_bright:\(current_bright)")
//    //        }
//    //    }
//
//    lazy var flagModel:FlagModel = {
//        let model = FlagModel(self)
//        return model
//    }()
//
//    lazy var flagModel2:FlagModel2 = {
//        let model = FlagModel2()
//        return model
//    }()
//
//    override func viewDidLoad() {
//        //        numL.text = "\(userPreferences.string(forKey: "major")!)    \(userPreferences.string(forKey: "sno")!)"
//        //        nameL.text = userPreferences.string(forKey: "name")
//
//        let major = gsno(userPreferences.string(forKey: "dep"))
//        let sno = gsno(userPreferences.string(forKey: "sno"))
//        let name = userPreferences.string(forKey: "name")
//
//        numL.text = "\(major)   \(sno)"
//        nameL.text = name
//
//        barcodeBG.layer.cornerRadius = 10.0
//        barcodeBG.clipsToBounds = true
//
//        setupUI()
//
//        //        current_bright = UIScreen.main.brightness
//    }
//
//
//    override func viewWillAppear(_ animated: Bool) {
//        //        print("flag")
//        //        let model = FlagModel(self)
//        flagModel.activeBarcode(1)
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        UIScreen.main.brightness = CGFloat(1.0)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        //        print("flag end")
//        flagModel2.deactiveBarcode(0)
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        UIScreen.main.brightness = CGFloat(userPreferences.float(forKey: "brightness"))
//    }
//
//    func setupUI(){
//        //        imageView.layer.cornerRadius = image_const.constant / 2
//        //        imageView.clipsToBounds = true
//        //        imageView.layer.borderColor = UIColor(r: 189, g: 189, b: 183).cgColor
//        //        imageView.layer.borderWidth = 2.0
//
//        no_internet_label.font = UIFont(name: "KoPubDotumPB", size: 24)
//        no_internet_label.text = "인터넷 연결을\n체크해주세요!"
//        no_internet_label.isHidden = true
//
//        titleL.font = UIFont(name: "KoPubDotumPB", size: 18)
//
//        nameL.font = UIFont(name: "KoPubDotumPB", size: 30)
//        numL.font = UIFont(name: "KoPubDotumPB", size: 16)
//
//        let attributes = [
//            NSAttributedStringKey.foregroundColor: UIColor(r: 189, g:189, b:183),
//            .font : UIFont(name: "KoPubDotumPB", size: 15)!
//        ]
//        var string = NSAttributedString(string: "로그아웃", attributes: attributes)
//        logoutB = TextImageButton()
//        self.view.addSubview(logoutB)
//        self.view.acwf(width: 87, height: 24, view: logoutB)
//        self.view.ac_center(item: logoutB, toItem: self.view, origin: "x")
//        self.view.addConstraint(NSLayoutConstraint(item: logoutB, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -27))
//
//        logoutB.setAttributedTitle(string, for: .normal)
//        logoutB.setImage(UIImage(named: "btnLogout"), for: .normal)
//        logoutB.spacing = 10
//        logoutB.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
//
//        infoB = TextImageButton()
//        self.view.addSubview(infoB)
//        self.view.acwf(width: 78, height: 24, view: infoB)
//        self.view.ac_center(item: infoB, toItem: self.view, origin: "x")
//
//
//        string = NSAttributedString(string: "앱 정보", attributes: attributes)
//        infoB.setAttributedTitle(string, for: .normal)
//        infoB.setImage(UIImage(named: "btnInfo"), for: .normal)
//        infoB.spacing = 10
//        infoB.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
//
//        string = NSAttributedString(string: "문의하기", attributes: attributes)
//        csrB = TextImageButton()
//        csrB.setAttributedTitle(string, for: .normal)
//        csrB.setImage(UIImage(named: "btnCsr"), for: .normal)
//        csrB.spacing = 10
//        self.view.addSubview(csrB)
//        self.view.acwf(width: 86, height: 23, view: csrB)
//        self.view.ac_center(item: csrB, toItem: self.view, origin: "x")
//
//        csrB.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
//
//
//        if DeviceUtil.smallerThanSE() == true {
//            print("smaller than se")
//            titleL_top.constant = titleL_top.constant / 2
//            barcode_top_const.constant = barcode_top_const.constant / 2
//            guideL_top_const.constant = guideL_top_const.constant / 2
//            barcode_width.constant = barcode_width.constant * 0.75
//            barcode_height.constant = barcode_height.constant * 0.75
//            logo_Top.constant = logo_Top.constant / 2
//            //            numL_top.constant = numL_top.constant / 2
//            //            nameL_top.constant = nameL_top.constant / 2
//
//
//            self.view.addConstraint(NSLayoutConstraint(item: infoB, attribute: .bottom, relatedBy: .equal, toItem: logoutB, attribute: .top, multiplier: 1, constant: -34.5/2))
//            self.view.addConstraint(NSLayoutConstraint(item: csrB, attribute: .bottom, relatedBy: .equal, toItem: infoB, attribute: .top, multiplier: 1, constant: -34.5/2))
//        } else {
//            self.view.addConstraint(NSLayoutConstraint(item: infoB, attribute: .bottom, relatedBy: .equal, toItem: logoutB, attribute: .top, multiplier: 1, constant: -34.5))
//            self.view.addConstraint(NSLayoutConstraint(item: csrB, attribute: .bottom, relatedBy: .equal, toItem: infoB, attribute: .top, multiplier: 1, constant: -34.5))
//        }
//
//        self.view.layoutIfNeeded()
//
//
//        //        string = NSAttributedString(string: "앱 정보", attributes: attributes)
//        //        infoBtn.setAttributedTitle(string, for: .normal)
//
//        //        let attributes:[String:Any] = [
//        //            NSForegroundColorAttributeName: UIColor.white,
//        //            NSFontAttributeName : UIFont(name: "KoPubDotumPB", size: 12)!
//        //        ]
//        //        let string = NSAttributedString(string: "주문번호 초기화", attributes: attributes)
//        //        let cb = TextImageButton()
//        //        cb.setAttributedTitle(string, for: .normal)
//        //        cb.setImage(UIImage(named: "mynumber_cancel"), for: .normal)
//        //        cb.spacing = 5+15
//        //        cb.contentEdgeInsets = UIEdgeInsets(top: 11, left: 15+15, bottom: 11, right: 15) //136 48
//        //        cb.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
//
//        guideL.font = UIFont(name: "KoPubDotumPL", size: 13)
//        guideL.text = "기숙사 식당에서 조식할인 시간에\n사용하실 수 있습니다."
//
//
//    }
//
//    @IBAction func barcodeClicked(_ sender: Any) {
//        self.delegate?.passData(resultData: true, code: "barcode")
//    }
//
//    @objc func btnClicked(_ sender: UIButton){
//        if sender == self.logoutB {
//            //            self.delegate?.passData(resultData: true, code: "logout")
//            self.pushVC(vc: "logout")
//        }
//
//        if sender == self.infoB {
//            //            self.delegate?.passData(resultData: true, code: "info")
//            self.pushVC(vc: "info")
//        }
//
//        if sender == self.csrB {
//            self.pushVC(vc: "csr")
//            //            self.delegate?.passData(resultData: true, code: "csr")
//        }
//    }
//
//    func pushVC(vc: String){
//        if let drawer = parent as? KYDrawerController, let nav = drawer.mainViewController as? UINavigationController {
//            drawer.setDrawerState(.closed, animated: true)
//
//            DispatchQueue.main.async {
//                //                let sb = UIStoryboard(name: "Main", bundle: nil)
//                //                switch vc {
//                //                case "csr":
//                //                    guard let csrvc = sb.instantiateViewController(withIdentifier: "csrvc") as? CsrVC else {return}
//                //                    nav.pushViewController(csrvc, animated: true)
//                //                case "info":
//                //                    guard let infovc = sb.instantiateViewController(withIdentifier: "infovc") as? InfoVC else {return}
//                //                    self.present(infovc, animated: true, completion: nil)
//                //                case "logout":
//                //                    let alertController = UIAlertController(title: nil, message: String.logout, preferredStyle: .alert)
//                //                    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//                //                    let ok = UIAlertAction(title: "확인", style: .default) { res -> Void in
//                //                        if let vc = nav.viewControllers.first as? HomeVC {
//                //                            let model = LoginModel(vc)
//                //                            model.logout()
//                //                        }
//                //                        if let vc = nav.viewControllers.first as? MyNumberVC {
//                //                            let model = LoginModel(vc)
//                //                            model.logout()
//                //                        }
//                //                    }
//                //                    alertController.addAction(ok)
//                //                    alertController.addAction(cancel)
//                //                    self.present(alertController, animated: true, completion: nil)
//                //                default:
//                //                    print()
//                //                }
//            }
//        }
//    }
//
//    //    @IBAction func logoutClicked(_ sender: Any) {
//    //        self.delegate?.passData(resultData: true, code: "logout")
//    //    }
//    //
//    //    @IBAction func infoClicked(_ sender: Any) {
//    //        self.delegate?.passData(resultData: true, code: "info")
//    //    }
//
//    func setBarcode(){
//        if userPreferences.object(forKey: "barcode") != nil {
//            no_internet_label.isHidden = true
//            barcodeIV.isHidden = false
//            let barcode = userPreferences.string(forKey: "barcode")
//            barcodeIV.image = generateBarcode(from: gsno(barcode))
//            barcodeIV.layer.cornerRadius = 5
//            barcodeIV.clipsToBounds = true
//        }
//    }
//
//    func removeBarcode(){
//        barcodeIV.isHidden = true
//        no_internet_label.isHidden = false
//        no_internet_label.layer.cornerRadius = 5
//        no_internet_label.clipsToBounds = true
//    }
//
//}
//
//extension DrawerVC2: NetworkCallback {
//    func networkResult(resultData: Any, code: String) {
//        if code == "activebarcode" {
//            if let code = resultData as? Int {
//                if code == 1 {
//                    setBarcode()
//                }
//            }
//        }
//    }
//
//    func networkFailed(code: Any) {
//        if let str = code as? String {
//            if str == "activebarcode" {
//                removeBarcode()
//            }
//        }
//    }
//
//    func networkFailed() {
//
//    }
//}
//

