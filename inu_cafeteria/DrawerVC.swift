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
    
    var delegate:ViewCallback?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var image_const: NSLayoutConstraint!
    
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var numL: UILabel!
    
    @IBOutlet weak var guideL: UILabel!
    
    var infoB: TextImageButton!
    var logoutB: TextImageButton!
    var csrB: TextImageButton!
    
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
        let model = FlagModel()
        model.activeBarcode(1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        print("flag end")
        let model = FlagModel()
        model.activeBarcode(0)
    }
    
    func setupUI(){
//        imageView.layer.cornerRadius = image_const.constant / 2
//        imageView.clipsToBounds = true
//        imageView.layer.borderColor = UIColor(r: 189, g: 189, b: 183).cgColor
//        imageView.layer.borderWidth = 2.0
        
        nameL.font = UIFont(name: "KoPubDotumPB", size: 18)
        numL.font = UIFont(name: "KoPubDotumPL", size: 15)
        
        let attributes:[String:Any] = [
            NSForegroundColorAttributeName: UIColor(r: 189, g:189, b:183),
            NSFontAttributeName : UIFont(name: "KoPubDotumPB", size: 15)!
        ]
        var string = NSAttributedString(string: "로그아웃", attributes: attributes)
        logoutB = TextImageButton()
        self.view.addSubview(logoutB)
        self.view.acwf(width: 87, height: 24, view: logoutB)
        self.view.ac_center(item: logoutB, toItem: self.view, origin: "x")
        self.view.addConstraint(NSLayoutConstraint(item: logoutB, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -36))
        
        logoutB.setAttributedTitle(string, for: .normal)
        logoutB.setImage(UIImage(named: "btnLogout"), for: .normal)
        logoutB.spacing = 10
        logoutB.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
        
        infoB = TextImageButton()
        self.view.addSubview(infoB)
        self.view.acwf(width: 78, height: 24, view: infoB)
        self.view.ac_center(item: infoB, toItem: self.view, origin: "x")
        self.view.addConstraint(NSLayoutConstraint(item: infoB, attribute: .bottom, relatedBy: .equal, toItem: logoutB, attribute: .top, multiplier: 1, constant: -22))
        
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
        self.view.addConstraint(NSLayoutConstraint(item: csrB, attribute: .bottom, relatedBy: .equal, toItem: infoB, attribute: .top, multiplier: 1, constant: -23))
        csrB.addTarget(self, action: #selector(btnClicked(_:)), for: .touchUpInside)
        
        
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
        
        if userPreferences.object(forKey: "barcode") != nil {
            let barcode = userPreferences.string(forKey: "barcode")
            barcodeIV.image = generateBarcode(from: gsno(barcode))
            barcodeIV.layer.cornerRadius = 5
            barcodeIV.clipsToBounds = true
        }
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
    
}
