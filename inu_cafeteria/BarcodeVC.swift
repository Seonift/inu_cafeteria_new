//
//  BarcodeVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 19..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit

class BarcodeVC: UIViewController {
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var image_const: NSLayoutConstraint!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var numL: UILabel!
    
    @IBOutlet weak var barcodeBV: UIView!
    
    override func viewDidLoad() {
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameL.text = "김선일"
        numL.text = "정보통신공학과    201101720"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let logoIV = UIImageView(image: UIImage(named: "nav_logo"))
        logoIV.contentMode = .scaleAspectFit
        logoIV.frame = CGRect(x: 0, y: 0, width: 130, height: 21.5)
        self.navigationItem.titleView = logoIV
    }
    
    func setupUI(){
        imageV.layer.cornerRadius = image_const.constant / 2
        imageV.clipsToBounds = true
        
        imageV.layer.borderColor = UIColor(r: 189, g: 189, b: 183).cgColor
        imageV.layer.borderWidth = 2.0
        
        nameL.font = UIFont(name: "KoPubDotumPB", size: 18)
        numL.font = UIFont(name: "KoPubDotumPL", size: 18)
        
        barcodeBV.layer.cornerRadius = 10
        barcodeBV.clipsToBounds = true
        
    }
}
