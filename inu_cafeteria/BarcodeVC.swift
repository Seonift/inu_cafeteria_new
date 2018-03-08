////
////  BarcodeVC.swift
////  inu_cafeteria
////
////  Created by SeonIl Kim on 2017. 7. 19..
////  Copyright © 2017년 appcenter. All rights reserved.
////
//
//import UIKit
//
//class BarcodeVC: UIViewController {
//    
//    @IBOutlet weak var imageV: UIImageView!
//    @IBOutlet weak var image_const: NSLayoutConstraint!
//    @IBOutlet weak var image_height: NSLayoutConstraint!
//    @IBOutlet weak var image_top: NSLayoutConstraint!
//    
//    @IBOutlet weak var nameL: UILabel!
//    
//    @IBOutlet weak var numL: UILabel!
//    
//    @IBOutlet weak var barcodeIV: UIImageView!
//    
//    @IBOutlet weak var barcodeBV: UIView!
//    @IBOutlet weak var barcode_width: NSLayoutConstraint!
//    @IBOutlet weak var barcode_height: NSLayoutConstraint!
//    
//    override func viewDidLoad() {
//        
//        setupUI()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        nameL.text = "김선일"
//        numL.text = "정보통신공학과    201101720"
//        
//        let barcode = userPreferences.string(forKey: "barcode")
//        
//        barcodeIV.image = generateBarcode(from: gsno(barcode))
//        
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        let logoIV = UIImageView(image: UIImage(named: "nav_logo"))
//        logoIV.contentMode = .scaleAspectFit
//        logoIV.frame = CGRect(x: 0, y: 0, width: 130, height: 21.5)
//        self.navigationItem.titleView = logoIV
//    }
//    
//    func setupUI() {
//        image_top.constant = DeviceUtil.getHeight(height: image_top.constant)
//        var width = DeviceUtil.getWidth(width: image_const.constant)
//        image_const.constant = width
//        image_height.constant = width
//        
//        imageV.layer.cornerRadius = width / 2
//        imageV.clipsToBounds = true
//        
//        imageV.layer.borderColor = UIColor(r: 189, g: 189, b: 183).cgColor
//        imageV.layer.borderWidth = 2.0
//        
//        nameL.font = UIFont(name: "KoPubDotumPB", size: 18)
//        numL.font = UIFont(name: "KoPubDotumPL", size: 18)
//        
//        barcodeBV.layer.cornerRadius = DeviceUtil.getWidth(width: 10)
//        barcodeBV.clipsToBounds = true
//        width = DeviceUtil.getWidth(width: barcode_width.constant)
//        barcode_width.constant = width
//        barcode_height.constant = width
//        
//    }
//}
