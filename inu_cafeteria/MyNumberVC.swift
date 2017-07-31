//
//  MyNumberVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 18..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import TextImageButton

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
//    var number:Int = 0 {
//        didSet {
//            if numberL != nil {
//                numberL.text = String(number)
//            }
//        }
//    }
    
    var numbers:[Int] = [-1,-1,-1] {
        didSet {
            if numberL != nil {
                if numbers[1] == -1 {
                    numberL.text = String(numbers[0])
                } else if numbers[2] == -1 {
                    numberL.text = "\(String(numbers[0])) \(String(numbers[1]))"
                } else {
                    numberL.text = "\(String(numbers[0])) \(String(numbers[1])) \(String(numbers[2]))"
                }
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
        numberL.font = UIFont(name: "KoPubDotumPB", size: 55)
        numberTitleL.font = UIFont(name: "KoPubDotumPB", size: 15)
        cView.isScrollEnabled = false
        cView.isUserInteractionEnabled = false
        
        let layout = cView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = DeviceUtil.getWidth(width: 42)
        layout.minimumLineSpacing = DeviceUtil.getHeight(height: 32)
//        cView.collectionViewLayout = layout
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
//        imageView.addGestureRecognizer(tap)
//        imageView.isUserInteractionEnabled = true
        
        let attributes:[String:Any] = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName : UIFont(name: "KoPubDotumPB", size: 12)!
        ]
        let string = NSAttributedString(string: "주문번호 초기화", attributes: attributes)
        let cb = TextImageButton()
        cb.setAttributedTitle(string, for: .normal)
        cb.setImage(UIImage(named: "mynumber_cancel"), for: .normal)
        cb.spacing = 5
        cb.contentEdgeInsets = UIEdgeInsets(top: 11, left: 15, bottom: 11, right: 15) //136 48
        cb.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
        
        self.view.addSubview(cb)
        self.view.acwf(width: 136, height: 48, view: cb)
        self.view.addConstraint(NSLayoutConstraint(item: cb, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: cb, attribute: .bottom, relatedBy: .equal, toItem: self.imageView, attribute: .bottom, multiplier: 1, constant: 0))
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let logoIV = UIImageView(image: UIImage(named: "nav_logo"))
        logoIV.contentMode = .scaleAspectFit
        logoIV.frame = CGRect(x: 0, y: 0, width: 130, height: 21.5)
        self.navigationItem.titleView = logoIV
        
        //분기를 설정. push가 왔으면 소켓을 설정하지 않고, vc를 닫는다.
        if userPreferences.object(forKey: "socket") == nil {
            print("socket start")
            userPreferences.setValue(true, forKey: "socket")
            userPreferences.setValue(numbers[0], forKey: "num1")
            if numbers[1] != -1 {
                userPreferences.setValue(numbers[1], forKey: "num2")
            }
            if numbers[2] != -1 {
                userPreferences.setValue(numbers[2], forKey: "num3")
            }
            userPreferences.setValue(code, forKey: "code")
        } else if userPreferences.bool(forKey: "socket") == false {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.bTitle = { self.bTitle }()
//        self.number = { self.number }()
        self.numbers = { self.numbers }()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("socket end")
        print("viewwilldisapper")
        userPreferences.removeObject(forKey: "socket")
        userPreferences.removeObject(forKey: "num1")
        userPreferences.removeObject(forKey: "num2")
        userPreferences.removeObject(forKey: "num3")
        userPreferences.removeObject(forKey: "code")
    }
    
//    func close(){
//        
//    }

    override func networkResult(resultData: Any, code: String) {
        if code == "logout" {
            logout_ncb()
        }
    }
    
    func cancelClicked() {
        let alertController = UIAlertController(title: nil, message: Strings.cancel_num(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "확인", style: .default) { res -> Void in
            self.dismiss(animated: false, completion: nil)
        }
        alertController.addAction(ok)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
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
