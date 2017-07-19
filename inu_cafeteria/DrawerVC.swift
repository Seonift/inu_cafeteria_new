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
    @IBOutlet weak var barcodeBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    
    override func viewDidLoad() {
        
        setupUI()
    }
    
    func setupUI(){
        imageView.layer.cornerRadius = image_const.constant / 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor(r: 189, g: 189, b: 183).cgColor
        imageView.layer.borderWidth = 2.0
        
        nameL.font = UIFont(name: "KoPubDotumPB", size: 18)
        
        var attributes = [
            NSForegroundColorAttributeName: UIColor(r: 144, g:186, b:203),
            NSFontAttributeName : UIFont(name: "KoPubDotumPB", size: 18)
        ]
        var string = NSAttributedString(string: "학생 바코드", attributes: attributes)
        barcodeBtn.setAttributedTitle(string, for: .normal)
        attributes = [
            NSForegroundColorAttributeName: UIColor(r: 189, g:189, b:183),
            NSFontAttributeName : UIFont(name: "KoPubDotumPB", size: 18)
        ]
        string = NSAttributedString(string: "로그아웃", attributes: attributes)
        logoutBtn.setAttributedTitle(string, for: .normal)
    }
    
    @IBAction func barcodeClicked(_ sender: Any) {
        self.delegate?.passData(resultData: true, code: "barcode")
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
    }
}
