//
//  DrawerVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 19..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit

class DrawerVC: UIViewController {
    
    var delegate:ViewCallback?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var image_const: NSLayoutConstraint!
    
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var numL: UILabel!
    
    
    @IBOutlet weak var logoutBtn: UIButton!
    
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
        imageView.layer.cornerRadius = image_const.constant / 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor(r: 189, g: 189, b: 183).cgColor
        imageView.layer.borderWidth = 2.0
        
        nameL.font = UIFont(name: "KoPubDotumPB", size: 18)
        numL.font = UIFont(name: "KoPubDotumPL", size: 15)
        
        let attributes:[String:Any] = [
            NSForegroundColorAttributeName: UIColor(r: 189, g:189, b:183),
            NSFontAttributeName : UIFont(name: "KoPubDotumPB", size: 15)!
        ]
        let string = NSAttributedString(string: "로그아웃", attributes: attributes)
        logoutBtn.setAttributedTitle(string, for: .normal)
        
        let barcode = userPreferences.string(forKey: "barcode")
        barcodeIV.image = generateBarcode(from: gsno(barcode))
    }
    
    @IBAction func barcodeClicked(_ sender: Any) {
        self.delegate?.passData(resultData: true, code: "barcode")
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        self.delegate?.passData(resultData: true, code: "logout")
    }
}
