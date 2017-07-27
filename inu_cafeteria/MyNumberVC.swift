//
//  MyNumberVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 18..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit

class MyNumberVC: UIViewController {
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var numberL: UILabel!
    @IBOutlet weak var numberTitleL: UILabel!
    
    @IBOutlet weak var cView: UICollectionView!
    
    let cellId = "NumberCell"
    
    let items = ["501", "502", "503", "504", "505", "506", "507", "508", "509", "510", "511", "512"]
    
    var bTitle:String = "" {
        didSet {
            if titleL != nil {
                titleL.text = bTitle
            }
        }
    }
    var number:Int = 0 {
        didSet {
            if numberL != nil {
                numberL.text = String(number)
            }
        }
    }
    
    var code:Int = 0
    
    @IBOutlet weak var image_height: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        setupDrawerBtn()
        
        let height = DeviceUtil.getHeight(height: image_height.constant)
        image_height.constant = height
        
        Indicator.stopAnimating()
        
        titleL.font = UIFont(name: "KoPubDotumPB", size: 20)
        numberL.font = UIFont(name: "KoPubDotumPB", size: 72)
        numberTitleL.font = UIFont(name: "KoPubDotumPB", size: 15)
        cView.isScrollEnabled = false
        cView.isUserInteractionEnabled = false
        
        let layout = cView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = DeviceUtil.getWidth(width: 42)
        layout.minimumLineSpacing = DeviceUtil.getHeight(height: 32)
//        cView.collectionViewLayout = layout
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let logoIV = UIImageView(image: UIImage(named: "nav_logo"))
        logoIV.contentMode = .scaleAspectFit
        logoIV.frame = CGRect(x: 0, y: 0, width: 130, height: 21.5)
        self.navigationItem.titleView = logoIV
        
        print("socket start")
        userPreferences.setValue(true, forKey: "socket")
        userPreferences.setValue(number, forKey: "number")
        userPreferences.setValue(code, forKey: "code")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.bTitle = { self.bTitle }()
        self.number = { self.number }()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("socket end")
        userPreferences.removeObject(forKey: "socket")
        userPreferences.removeObject(forKey: "number")
        userPreferences.removeObject(forKey: "code")
    }
    
    func close(){
        self.dismiss(animated: false, completion: nil)
    }

    override func networkResult(resultData: Any, code: String) {
        if code == "logout" {
            logout_ncb()
        }
    }
}

extension MyNumberVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NumberCell
        cell.label.text = items[indexPath.row]
        return cell
    }
}

class NumberCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        label.font = UIFont(name: "KoPubDotumPB", size: 24)
        label.textColor = UIColor(r: 98, g: 150, b: 174)
    }
}
