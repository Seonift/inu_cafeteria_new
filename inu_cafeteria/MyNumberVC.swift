//
//  MyNumberVC.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 18..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import TextImageButton
import SocketIO
import Toaster
import AVFoundation

class MyNumberVC: UIViewController {
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var numberL: UILabel!
    @IBOutlet weak var numberTitleL: UILabel!
    
    @IBOutlet weak var cView: UICollectionView!
    
    let cellId = "NumberCell"
    let cellId2 = "NumberCell2"
    
    var items: [String] = [] {
        didSet {
            if cView != nil {
                cView.reloadData()
            }
            if items.count > 12 {
                self.start_index += 1
            }
        }
    }
    
    var start_index:Int = 0
//    var queue:[Int] = [] {
//        didSet {
//            if cView != nil {
//                cView.reloadData()
//            }
//        }
//    }
//    var front:Int = 0
//    var rear:Int = 0
    
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
    
    var numbers:[Int] = [] {
        didSet {
            if numberL != nil {
                if numbers.count == 1 {
                    numberL.text = String(numbers[0])
                } else if numbers.count == 2 {
                    numberL.text = "\(String(numbers[0])) \(String(numbers[1]))"
                } else if numbers.count == 3 {
                    numberL.text = "\(String(numbers[0])) \(String(numbers[1])) \(String(numbers[2]))"
                }
            }
            userPreferences.setValue(numbers.count, forKey: "num_count")
        }
    }
    
    var code:Int = 0
    var name:String = ""
    
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
        
//        cView.register(NumberCell.self, forCellWithReuseIdentifier: cellId2)
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
        
//        SocketIOManager.sharedInstance.establishConnection()
        
        
        
        //분기를 설정. push가 왔으면 소켓을 설정하지 않고, vc를 닫는다.
//        if userPreferences.object(forKey: "socket") == nil {
//            print("socket start")
//            userPreferences.setValue(true, forKey: "socket")
//            userPreferences.setValue(numbers[0], forKey: "num1")
//            if numbers.count == 2 {
//                userPreferences.setValue(numbers[1], forKey: "num2")
//            }
//            if numbers.count == 3 {
//                userPreferences.setValue(numbers[2], forKey: "num3")
//            }
//            userPreferences.setValue(code, forKey: "code")
//        } else if userPreferences.bool(forKey: "socket") == false {
//            self.dismiss(animated: false, completion: nil)
//        }
    }
    
    func setSocketConnect(){
        print("setsocket, code:\(String(self.code))")
        SocketIOManager.sharedInstance.getNumber(code: String(self.code)) { (result) -> Void in
            DispatchQueue.main.async {
//                print("receive socket")
                print(result[0])
                if let res = result[0] as? NSDictionary {
//                    print(msg["msg"])
                    if let msg = res["msg"] as? String {
                        let msgint = gino(Int(msg))
                        print("msgint:\(msgint)")
                        if self.checkNumCorrect(msgint) == true {
                            //내 번호가 나오면 알림
                           
                            
                            let alertController = UIAlertController(title: nil, message: Strings.complete_num(), preferredStyle: .alert)
                            let ok = UIAlertAction(title: "확인", style: .default) { res -> Void in
                                let model = NumberModel(self)
                                model.isNumberWait()
                            }
                            alertController.addAction(ok)
                            self.present(alertController, animated: true, completion: nil)
                            
                            let systemSoundID:SystemSoundID = 1005
                            let vib = SystemSoundID(kSystemSoundID_Vibrate)
                            AudioServicesPlaySystemSound(systemSoundID)
                            AudioServicesPlaySystemSound(vib)
                        } else {
                            self.items.append(msg)
                        }
//                        self.items.enqueue(gsno(msg))
//                        self.cView.reloadData()
                    }
                }
            }
        }
    }
    
    func checkNumCorrect(_ num:Int) -> Bool{
        print("checkNumCorrect:\(String(num))")
        //번호가 들어왔을때 맞는 번호인지 확인
        if numbers.count > 0 {
            for i in 0...numbers.count-1 {
                if numbers[i] == num {
                    return true
                }
            }
        }
        return false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.bTitle = { self.bTitle }()
//        self.number = { self.number }()
        self.numbers = { self.numbers }()
        
        setSocketConnect()
//        SocketIOManager.sharedInstance.connectToServer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        print("socket end")
        print("viewwilldisapper")
        
        numbers.removeAll()
        
//        userPreferences.removeObject(forKey: "socket")
//        userPreferences.removeObject(forKey: "num1")
//        userPreferences.removeObject(forKey: "num2")
//        userPreferences.removeObject(forKey: "num3")
//        userPreferences.removeObject(forKey: "code")
        
    }
    
//    func close(){
//        
//    }
    
    func wakeUp(){
        //background에서 복귀
        print("wakeup")
        
        Indicator.startAnimating(activityData)
        let model = NumberModel(self)
        model.isNumberWait()
        
        setSocketConnect()
    }

    override func networkResult(resultData: Any, code: String) {
        if code == "logout" {
            logout_ncb()
        }
        
        if code == "reset_num" {
            Indicator.stopAnimating()
            self.dismiss(animated: false, completion: nil)
        }
        
//        if code == "isnumberwait" {
//            //재설정
//        }
//        
        
        if code == "isnumberwait" {
//            connectSocket()
            
            print("networkresult:\(code)")
            let json = resultData as! NSDictionary
            
            var arr:[Int] = []
            
            let code = json["code"] as! String
            let num1 = Int(json["num1"] as! String)
            let num2 = Int(json["num2"] as! String)
            let num3 = Int(json["num3"] as! String)
            //            arr = [num1!, num2!, num3!]
            
            if num1 != -1 && num1 != nil {
                print("append num1")
                arr.append(num1!)
            }
            if num2 != -1 && num2 != nil {
                print("append num2")
                arr.append(num2!)
            }
            if num3 != -1 && num3 != nil {
                print("append num3")
                arr.append(num3!)
            }
            
            userPreferences.setValue(arr.count, forKey: "num_count")
            print(arr)
            
            numbers = arr
            
            Indicator.stopAnimating()
            
        }
    }
    
    override func networkFailed(code: Any) {
        if let str = code as? String {
            if str == "isnumberwait" {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    override func networkFailed() {
        Toast(text: Strings.noServer()).show()
        
        Indicator.stopAnimating()
    }
    
    func cancelClicked() {
        let alertController = UIAlertController(title: nil, message: Strings.cancel_num(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "확인", style: .default) { res -> Void in
            // 소켓 초기화
            Indicator.startAnimating(activityData)
            let model = NumberModel(self)
            model.resetNumber()
        }
        alertController.addAction(ok)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension MyNumberVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return items.count
        if items.count < 12 {
            return items.count
        } else {
            return 12
        }
        
//        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var text:String = ""
        if items.count > self.start_index + indexPath.row {
            text = items[self.start_index + indexPath.row]
        }
        if indexPath.row < 9 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NumberCell

            cell.label.text = text
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! NumberCell
            
            cell.label.text = text
            
            cell.isRed = true
            
            return cell
        }
    }
}

class NumberCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    var isRed:Bool = false {
        didSet {
            if isRed == true {
                if label != nil {
                    label.textColor = UIColor(r: 242, g: 108, b: 79)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        label.font = UIFont(name: "KoPubDotumPB", size: 24)
        label.textColor = UIColor(r: 98, g: 150, b: 174)
    }
}
