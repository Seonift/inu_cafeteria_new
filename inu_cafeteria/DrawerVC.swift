//
//  DrawerVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 19..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import TextImageButton

class DrawerVC: UIViewController {
    
    @IBOutlet weak var titleL: UILabel!
    
    var delegate:ViewCallback?
    @IBOutlet weak var no_internet_label: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var image_const: NSLayoutConstraint!
    
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var numL: UILabel!
    
    @IBOutlet weak var guideL: UILabel!
    
    var infoB: TextImageButton!
    var logoutB: TextImageButton!
    var csrB: TextImageButton!
    
    @IBOutlet weak var titleL_top: NSLayoutConstraint!
//    @IBOutlet weak var nameL_top: NSLayoutConstraint!
//    @IBOutlet weak var numL_top: NSLayoutConstraint!
    @IBOutlet weak var logo_Top: NSLayoutConstraint!
    @IBOutlet weak var barcode_top_const: NSLayoutConstraint!
    @IBOutlet weak var guideL_top_const: NSLayoutConstraint!
    
    @IBOutlet weak var barcode_width: NSLayoutConstraint!
    @IBOutlet weak var barcode_height: NSLayoutConstraint!
    
//    @IBOutlet weak var infoBtn: TextImageButton!
//    @IBOutlet weak var logoutBtn: TextImageButton!
    
    @IBOutlet weak var barcodeBG: UIView!
    @IBOutlet weak var barcodeIV: UIImageView!
    
    override func viewDidLoad() {
//        numL.text = "\(userPreferences.string(forKey: "major")!)    \(userPreferences.string(forKey: "sno")!)"
//        nameL.text = userPreferences.string(forKey: "name")
        
        let major = gsno(userPreferences.string(forKey: "dep"))
        let sno = gsno(userPreferences.string(forKey: "sno"))
        let name = userPreferences.string(forKey: "name")
        
        numL.text = "\(major)   \(sno)"
        nameL.text = name
        
        barcodeBG.layer.cornerRadius = 10.0
        barcodeBG.clipsToBounds = true
        
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        print("flag")
        let model = FlagModel(self)
        model.activeBarcode(1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        print("flag end")
        let model = FlagModel2()
        model.deactiveBarcode(0)
    }
    
    func setupUI(){
//        imageView.layer.cornerRadius = image_const.constant / 2
//        imageView.clipsToBounds = true
//        imageView.layer.borderColor = UIColor(r: 189, g: 189, b: 183).cgColor
//        imageView.layer.borderWidth = 2.0
        
        no_internet_label.font = UIFont(name: "KoPubDotumPB", size: 24)
        no_internet_label.text = "인터넷 연결을\n체크해주세요!"
        no_internet_label.isHidden = true
        
        titleL.font = UIFont(name: "KoPubDotumPB", size: 18)
        
        nameL.font = UIFont(name: "KoPubDotumPB", size: 30)
        numL.font = UIFont(name: "KoPubDotumPB", size: 16)
        
        let attributes:[String:Any] = [
            NSForegroundColorAttributeName: UIColor(r: 189, g:189, b:183),
            NSFontAttributeName : UIFont(name: "KoPubDotumPB", size: 15)!
        ]
        var string = NSAttributedString(string: "로그아웃", attributes: attributes)
        logoutB = TextImageButton()
        self.view.addSubview(logoutB)
        self.view.acwf(width: 87, height: 24, view: logoutB)
        self.view.ac_center(item: logoutB, toItem: self.view, origin: "x")
        self.view.addConstraint(NSLayoutConstraint(item: logoutB, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -27))
        
        logoutB.setAttributedTitle(string, for: .normal)
        logoutB.setImage(UIImage(named: "btnLogout"), for: .normal)
        logoutB.spacing = 10
        logoutB.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
        
        infoB = TextImageButton()
        self.view.addSubview(infoB)
        self.view.acwf(width: 78, height: 24, view: infoB)
        self.view.ac_center(item: infoB, toItem: self.view, origin: "x")
       
        
        string = NSAttributedString(string: "앱 정보", attributes: attributes)
        infoB.setAttributedTitle(string, for: .normal)
        infoB.setImage(UIImage(named: "btnInfo"), for: .normal)
        infoB.spacing = 10
        infoB.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
        
        string = NSAttributedString(string: "문의하기", attributes: attributes)
        csrB = TextImageButton()
        csrB.setAttributedTitle(string, for: .normal)
        csrB.setImage(UIImage(named: "btnCsr"), for: .normal)
        csrB.spacing = 10
        self.view.addSubview(csrB)
        self.view.acwf(width: 86, height: 23, view: csrB)
        self.view.ac_center(item: csrB, toItem: self.view, origin: "x")
        
        csrB.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
        
        
        if DeviceUtil.smallerThanSE() == true {
            print("smaller than se")
            titleL_top.constant = titleL_top.constant / 2
            barcode_top_const.constant = barcode_top_const.constant / 2
            guideL_top_const.constant = guideL_top_const.constant / 2
            barcode_width.constant = barcode_width.constant * 0.75
            barcode_height.constant = barcode_height.constant * 0.75
            logo_Top.constant = logo_Top.constant / 2
//            numL_top.constant = numL_top.constant / 2
//            nameL_top.constant = nameL_top.constant / 2
            
            
            self.view.addConstraint(NSLayoutConstraint(item: infoB, attribute: .bottom, relatedBy: .equal, toItem: logoutB, attribute: .top, multiplier: 1, constant: -34.5/2))
            self.view.addConstraint(NSLayoutConstraint(item: csrB, attribute: .bottom, relatedBy: .equal, toItem: infoB, attribute: .top, multiplier: 1, constant: -34.5/2))
        } else {
            self.view.addConstraint(NSLayoutConstraint(item: infoB, attribute: .bottom, relatedBy: .equal, toItem: logoutB, attribute: .top, multiplier: 1, constant: -34.5))
            self.view.addConstraint(NSLayoutConstraint(item: csrB, attribute: .bottom, relatedBy: .equal, toItem: infoB, attribute: .top, multiplier: 1, constant: -34.5))
        }
        
        self.view.layoutIfNeeded()
        
        
//        string = NSAttributedString(string: "앱 정보", attributes: attributes)
//        infoBtn.setAttributedTitle(string, for: .normal)
        
//        let attributes:[String:Any] = [
//            NSForegroundColorAttributeName: UIColor.white,
//            NSFontAttributeName : UIFont(name: "KoPubDotumPB", size: 12)!
//        ]
//        let string = NSAttributedString(string: "주문번호 초기화", attributes: attributes)
//        let cb = TextImageButton()
//        cb.setAttributedTitle(string, for: .normal)
//        cb.setImage(UIImage(named: "mynumber_cancel"), for: .normal)
//        cb.spacing = 5+15
//        cb.contentEdgeInsets = UIEdgeInsets(top: 11, left: 15+15, bottom: 11, right: 15) //136 48
//        cb.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
        
        guideL.font = UIFont(name: "KoPubDotumPL", size: 13)
        guideL.text = "기숙사 식당에서 조식할인 시간에\n사용하실 수 있습니다."
        
        
    }
    
    @IBAction func barcodeClicked(_ sender: Any) {
        self.delegate?.passData(resultData: true, code: "barcode")
    }
    
    func btnClicked(_ sender: UIButton){
        if sender == self.logoutB {
            self.delegate?.passData(resultData: true, code: "logout")
        }
        
        if sender == self.infoB {
            self.delegate?.passData(resultData: true, code: "info")
        }
        
        if sender == self.csrB {
            self.delegate?.passData(resultData: true, code: "csr")
        }
    }
    
//    @IBAction func logoutClicked(_ sender: Any) {
//        self.delegate?.passData(resultData: true, code: "logout")
//    }
//    
//    @IBAction func infoClicked(_ sender: Any) {
//        self.delegate?.passData(resultData: true, code: "info")
//    }
    
    func setBarcode(){
        if userPreferences.object(forKey: "barcode") != nil {
            no_internet_label.isHidden = true
            barcodeIV.isHidden = false
            let barcode = userPreferences.string(forKey: "barcode")
            barcodeIV.image = generateBarcode(from: gsno(barcode))
            barcodeIV.layer.cornerRadius = 5
            barcodeIV.clipsToBounds = true
        }
    }
    
    func removeBarcode(){
        barcodeIV.isHidden = true
        no_internet_label.isHidden = false
        no_internet_label.layer.cornerRadius = 5
        no_internet_label.clipsToBounds = true
    }
    
}

extension DrawerVC {
    override func networkResult(resultData: Any, code: String) {
        if code == "activebarcode" {
            if let code = resultData as? Int {
                if code == 1 {
                    setBarcode()
                }
            }
        }
    }
    
    override func networkFailed(code: Any) {
        if let str = code as? String {
            if str == "activebarcode" {
                removeBarcode()
            }
        }
    }
}
